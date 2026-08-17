pragma solidity ^0.4.24;

contract Main {
    // 患者结构体
    struct Sick {
        address accountAddress; //地址
        string name; //姓名
        string sex; //性别
        uint256 age; //年龄
        uint256 id; //身份证号
    }

    mapping(uint256 => Sick) public sicks;
    uint256[] public sickIds;

    // 事件
    event SickCreated(
        uint256 indexed id,
        address indexed accountAddress,
        string name,
        string sex,
        uint256 age
    );

    // 根据身份证号查询病人信息
    function getSickByIdentityNumber(
        uint256 identityNumber
    )
        public
        view
        returns (
            address accountAddress,
            string memory name,
            string memory sex,
            uint256 age,
            uint256 id
        )
    {
        Sick storage sick = sicks[identityNumber];
        require(sick.accountAddress != address(0), "Sick not found");
        return (sick.accountAddress, sick.name, sick.sex, sick.age, sick.id);
    }

    // 创建病人信息
    function createSick(
        string memory name,
        string memory sex,
        uint256 age,
        uint256 identityNumber,
        address accountAddress
    ) public {
        require(bytes(name).length > 0, "Invalid name");
        require(bytes(sex).length > 0, "Invalid sex");
        require(age > 0, "Invalid age");
        require(identityNumber > 0, "Invalid identityNumber");
        require(
            sicks[identityNumber].accountAddress == address(0),
            "Sick already exists"
        );

        sicks[identityNumber] = Sick({
            accountAddress: accountAddress,
            name: name,
            sex: sex,
            age: age,
            id: identityNumber
        });

        sickIds.push(identityNumber);

        emit SickCreated(identityNumber, msg.sender, name, sex, age);
    }

    // 查询病人列表
    function getSicksList() public view returns (uint256[] memory) {
        return sickIds;
    }

    // 患者是否存在
    function isSickExist(uint256 sickID) public view returns (bool) {
        return sicks[sickID].accountAddress != address(0);
    }

    event AppointmentCreated(
        uint256 indexed sickID,
        string hospitalName,
        string department
    );

    // 预约科室结构体
    struct Appointment {
        string hospitalName; // 医院名称，表示预约的医院
        string department; // 科室名称，表示预约的科室
    }

    // 存储患者预约信息的映射
    mapping(uint256 => Appointment) public sickAppointment;

    // 患者进行挂号预约
    function createAppointment(
        uint256 sickID,
        string memory hospitalName,
        string memory department
    ) public {
        require(isSickExist(sickID), "Sick not found");
        require(bytes(hospitalName).length > 0, "Invalid hospital name");
        require(bytes(department).length > 0, "Invalid department");

        Appointment memory appointment = Appointment({
            hospitalName: hospitalName,
            department: department
        });

        sickAppointment[sickID] = appointment;

        emit AppointmentCreated(sickID, hospitalName, department);
    }

    // 查询患者的预约信息
    function getSickAppointment(
        uint256 sickID
    )
        public
        view
        returns (string memory hospitalName, string memory department)
    {
        Appointment storage appointment = sickAppointment[sickID];
        require(
            bytes(appointment.hospitalName).length > 0,
            "Appointment not found"
        );
        return (appointment.hospitalName, appointment.department);
    }

    event MedicalRecordCreated(
        uint256 indexed sickID,
        string hospitalName,
        string department,
        string doctorName,
        string registrationInfo
    );
    // 病历资料结构体
    struct MedicalRecord {
        uint256 sickID;
        string hospitalName;
        string department;
        string doctorName;
        string registrationInfo;
        string pastMedicalHistory;
        string currentMedicalHistory;
        string isFilled;
    }

    // 存储患者病历信息的映射
    mapping(uint256 => MedicalRecord) public sickMedicalRecords;

    // 患者查询对应科室的既往病历
    function getPastMedicalHistory(
        uint256 sickID,
        string memory department
    ) public view returns (string memory) {
        MedicalRecord storage medicalRecord = sickMedicalRecords[sickID];
        require(
            bytes(medicalRecord.hospitalName).length > 0,
            "Medical record not found"
        );

        require(
            keccak256(abi.encodePacked(medicalRecord.department)) ==
                keccak256(abi.encodePacked(department)),
            "Department mismatch"
        );

        return medicalRecord.pastMedicalHistory;
    }

    // 授权医生查看病历
    function authorizeDoctor(
        uint256 sickID,
        string memory department,
        string memory doctorName
    ) public {
        require(isSickExist(sickID), "Sick not found");
        require(bytes(department).length > 0, "Invalid department");
        require(bytes(doctorName).length > 0, "Invalid doctor name");

        MedicalRecord storage medicalRecord = sickMedicalRecords[sickID];

        // 如果病历不存在，则自动创建一个新的病历
        if (bytes(medicalRecord.hospitalName).length == 0) {
            // 创建新的病历，并设置注册信息为 ""
            createMedicalRecord(sickID, "", department, "");
            medicalRecord = sickMedicalRecords[sickID];
        }

        // 设置医生姓名
        medicalRecord.doctorName = doctorName;

        emit MedicalRecordCreated(
            sickID,
            medicalRecord.hospitalName,
            medicalRecord.department,
            doctorName,
            medicalRecord.registrationInfo
        );
    }

    // 创建新的病历
    function createMedicalRecord(
        uint256 sickID,
        string memory hospitalName,
        string memory department,
        string memory registrationInfo
    ) public {
        require(isSickExist(sickID), "Sick not found");
        require(bytes(hospitalName).length > 0, "Invalid hospital name");
        require(bytes(department).length > 0, "Invalid department");

        MedicalRecord memory medicalRecord = MedicalRecord({
            sickID: sickID,
            hospitalName: hospitalName,
            department: department,
            doctorName: "",
            registrationInfo: registrationInfo,
            pastMedicalHistory: "",
            currentMedicalHistory: "",
            isFilled: "No"
        });

        sickMedicalRecords[sickID] = medicalRecord;

        emit MedicalRecordCreated(
            sickID,
            hospitalName,
            department,
            "",
            registrationInfo
        );
    }

    // 检查病历是否已经填写
    function isMedicalRecordFilled(uint256 sickID) public view returns (bool) {
        MedicalRecord storage medicalRecord = sickMedicalRecords[sickID];
        return
            keccak256(abi.encodePacked(medicalRecord.isFilled)) ==
            keccak256(abi.encodePacked("Yes"));
    }

    // 结束病历咨询
    function endMedicalConsultation(uint256 sickID, string mrtype) public {
        require(isSickExist(sickID), "Sick not found");

        MedicalRecord storage medicalRecord = sickMedicalRecords[sickID];
        require(
            bytes(medicalRecord.hospitalName).length > 0,
            "Medical record not found"
        );

        medicalRecord.isFilled = mrtype;
    }

    event MedicalRecordUpdated(
        uint256 indexed sickID,
        string hospitalName,
        string department,
        string registrationInfo,
        string pastMedicalHistory,
        string currentMedicalHistory
    );

    // 更新病历资料
    function updateMedicalRecord(
        uint256 sickID,
        string memory hospitalName,
        string memory department,
        string memory registrationInfo,
        string memory pastMedicalHistory,
        string memory currentMedicalHistory
    ) public {
        require(isSickExist(sickID), "Sick not found");
        require(bytes(hospitalName).length > 0, "Invalid hospital name");
        require(bytes(department).length > 0, "Invalid department");

        MedicalRecord storage medicalRecord = sickMedicalRecords[sickID];
        require(
            bytes(medicalRecord.hospitalName).length > 0,
            "Medical record not found"
        );

        // 更新病历资料
        medicalRecord.hospitalName = hospitalName;
        medicalRecord.department = department;
        medicalRecord.registrationInfo = registrationInfo;
        medicalRecord.pastMedicalHistory = pastMedicalHistory;
        medicalRecord.currentMedicalHistory = currentMedicalHistory;

        emit MedicalRecordUpdated(
            sickID,
            hospitalName,
            department,
            registrationInfo,
            pastMedicalHistory,
            currentMedicalHistory
        );
    }

    // 根据账户地址查询患者信息
    function getSickByAccountAddress(
        address accountAddr
    )
        public
        view
        returns (string memory name, string memory sex, uint256 age, uint256 id)
    {
        uint256 sickID = findSickIDByAccountAddress(accountAddr);
        require(sickID != 0, "Sick not found");

        Sick storage sick = sicks[sickID];
        return (sick.name, sick.sex, sick.age, sick.id);
    }

    // 辅助函数：根据账户地址查找患者ID
    function findSickIDByAccountAddress(
        address accountAddr
    ) internal view returns (uint256) {
        for (uint256 i = 0; i < sickIds.length; i++) {
            uint256 sickID = sickIds[i];
            if (sicks[sickID].accountAddress == accountAddr) {
                return sickID;
            }
        }
        return 0; // Return 0 if the sick with the given account address is not found
    }

    // 新增函数：根据身份证号查询病历
    function getMedicalRecordByIdentityNumber(
        uint256 sickID
    )
        public
        view
        returns (
            string memory hospitalName,
            string memory department,
            string memory doctorName,
            string memory registrationInfo,
            string memory pastMedicalHistory,
            string memory currentMedicalHistory
        )
    {
        MedicalRecord storage medicalRecord = sickMedicalRecords[sickID];

        return (
            medicalRecord.hospitalName,
            medicalRecord.department,
            medicalRecord.doctorName,
            medicalRecord.registrationInfo,
            medicalRecord.pastMedicalHistory,
            medicalRecord.currentMedicalHistory
        );
    }

    function deleteSickAppointment(uint256 sickID) public {
        require(isSickExist(sickID), "Sick not found");

        delete sickAppointment[sickID];
    }
}
