class APIEndPoints {
  // static const live = 'https://www.gradding.com/api/mobile-api/v1/';
  static const live = 'https://fluttertales.tech/mobileapi/v1/';
  // static const local = 'http://192.168.43.65:9090/mobileapi/v1/'; // sumit api
  static const local = 'http://10.144.61.4:3001/api/';

  // static const beta = 'https://beta-web.gradding.com/api/mobile-api/v1/';
  // static const stagging = 'https://beta-web.gradding.com/api/mobile-api/v1/';

  static const base = local;

  static const updateFcmToken = 'auth/update-fcm-token';
  static const getClientProfile = 'auth/get-client-profile';
  static const changePassword = 'auth/change-password';

  static const getAnnouncements = 'announcements/get-announcements';

  static const getAttendanceByUserAndDate = "attendance/get-attendance-by-user-and-date";

  // http://localhost:9090/mobileapi/v1/exams/mcq/1
  static const getExam = "exams/mcq/1";
  static const sendClientQuery = "email/send/clientquery";


  //   CineMarathi
  static const clientLogin = "auth/login";
  static const getDashboard = "users/dashboard";
  static const talentCategories = "users/talent/categories";
  
  // Upload endpoints
  static const uploadProfileImage = "upload/profile";
  static const uploadFile = "upload/file";
  
  // Portfolio endpoints
  static const getPortfolioImages = "portfolio/images";
  static const uploadPortfolioImages = "portfolio/images";
  static const updatePortfolioImage = "portfolio/images"; // PUT with index
  static const deletePortfolioImage = "portfolio/images"; // DELETE with index
  static const clearPortfolioImages = "portfolio/images"; // DELETE all
  
  // Profile endpoints
  static const updateProfile = "users/profile";
  
}
