class ApiConstants {
  static const String hospitalCodeURL =
      "https://developmentapiconnector.dynamicemr.net/api/CodeUrl";

  // Account
  static const String getUserBranches = "/Account/GetUserBranches";
  static const String getUserFinancialYear = "/Account/GetUserFinancialYear";
  static const String userLogin = "/Account/LoginUser";
  static const String userRefreshToken = "/Account/RefreshToken/refresh";

  // Attendance
  static const String getCurrentMonthAttendanceSheetPrimary =
      "/api/EmployeeAttendance/GetMyCurrentMonthAttendanceSheetPrimary";
  static const String getCurrentMonthAttendanceSheetExtended =
      "/api/EmployeeAttendance/GetMyCurrentMonthAttendanceSheetExtended";
  static const String getMyAttendanceSummary =
      "/api/EmployeeAttendance/GetMyAttendanceSummary";

  // Work (Task)
  static const String getTicketCategories = "/api/Ticket/GetTicketCategories";
  static const String getUserList = "/api/Ticket/GetUserList";
  // Default Id is passed as 102
  static const String getTicketDetailsById = "/api/Ticket/GetTicketDetailById";
  static const String getMyTicketSummary = "/api/Ticket/GetMyTicketSummary";
  static const String getTicketAssignedToMe =
      "/api/Ticket/GetTicketAssignedToMeSummary";
  static const String myTicket = "/api/Ticket/MyTickets";
  static const String ticketAssignedToMe = "/api/Ticket/TicketsAssignedToMe";
  static const String editPriority = "/api/Ticket/EditPriority";
  static const String editSeverity = "/api/Ticket/EditSeverity";
  static const String editAssignedTo = "/api/Ticket/EditAssignedTo";
  static const String closeTicket = "/api/Ticket/CloseTicket";
  static const String reOpenTicket = "/api/Ticket/ReOpenTicket";
  static const String createTicketPost = "/api/Ticket/CreateTicketPost";
  static const String commentPost = "/api/Ticket/CommentPost";

  // Leave Info

  static const String getLeaveTypes = "/api/LeaveApplication/GetLeaveTypes";
  static const String getContracts = "/api/LeaveApplication/GetContracts";
  static const String getContractFiscalYearByContctId =
      "/api/LeaveApplication/GetContractFiscalYearByContctId";
  static const String employeeLeaveHistoryByContractIdAndFiscalYearId =
      "/api/LeaveApplication/EmployeeLeaveHistoryByContractIdAndFiscalYearId";

  static const String employeeLeavesByContractIdAndFiscalYearId =
      "/api/LeaveApplication/EmployeeLeavesByContractIdAndFiscalYearId";
  static const String getExtendedLeaveTypes =
      "/api/LeaveApplication/GetExtendedLeaveTypes";
  static const String getSubstitutionEmployee =
      "/api/LeaveApplication/GetSubstitutionEmployee";
  static const String getEmployeeLeaveHistory =
      "/api/LeaveApplication/EmployeeLeaveHistory";
  static const String employeeLeaves = "/api/LeaveApplication/EmployeeLeaves";
  static const String approvedEmployeeLeavesToCome =
      "/api/LeaveApplication/ApprovedEmployeeLeavesToCome";
  static const String pendingEmployeeLeavesToCome =
      "/api/LeaveApplication/NotApprovedEmployeeLeavesToCome";
  // Apply leave
  static const String leaveApplicationPost =
      "/api/LeaveApplication/LeaveApplicationPost";

  // Holiday
  static const String getHolidayList = "/api/HolidayList/GetHolidayList";
  static const String getPastHolidayList =
      "/api/HolidayList/GetPastHolidayList";
  static const String getUpcommingHolidayList =
      "/api/HolidayList/GetUpcommingHolidayList";

  // Notice
  static const String getAllNotices = "/api/Notice/GetAllNotices";
  static const String getPagedNotices = "/api/Notice/GetPagedNotices";
  static const String getNoticeById = "/api/Notice/GetNoticeById/1";

  // Profile (Employee)
  static const String getEmployeeDetail = "/api/Employee/GetEmployeeDetail";
  static const String punchPost = "/api/Employee/PunchPost";
  static const String liveLocationSharePost =
      "/api/Employee/LiveLocationSharePost";

  // contracts
  static const String getEmployeeContracts =
      "/api/EmployeeContract/GetEmployeeContracts";

  // Payrolls (Monthly Salary)
  static const String getMyCurrentMonthSalary =
      "/api/Payroll/GetMyCurrentMonthSalary";
  static const String getMyMonthSalary = "/api/Payroll/GetMyMonthSalary";

  // Payrolls (Loan and Advances)
  static const String getMyLoanAndAdvances =
      "/api/Payroll/GetMyLoanAndAdvances";
  static const String getMyTaxes = "/api/Payroll/GetMyTaxes";

  // Machine Attendence
  static const String postMachineAttendance =
      "Api/MachineAttendance/PostMachineAttendance";
  static const String getTodayPunches = "/api/Employee/GetTodayPunches";
}
