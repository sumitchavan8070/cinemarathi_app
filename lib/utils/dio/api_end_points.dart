class APIEndPoints {
  // static const live = 'https://www.gradding.com/api/mobile-api/v1/';
  static const live = 'https://fluttertales.tech/mobileapi/v1/';
  // static const local = 'http://192.168.43.65:9090/mobileapi/v1/'; // sumit api
  static const local = 'http://10.144.61.4:3001/api/';
  // static const local = 'http://192.168.43.65:3001/api/';

  // static const beta = 'https://beta-web.gradding.com/api/mobile-api/v1/';
  // static const stagging = 'https://beta-web.gradding.com/api/mobile-api/v1/';

  static const base = local;

  static const updateFcmToken = 'auth/update-fcm-token';
  static const getClientProfile = 'auth/get-client-profile';
  static const changePassword = 'auth/change-password';

  static const getAnnouncements = 'announcements/get-announcements';

  static const getAttendanceByUserAndDate = "attendance/get-attendance-by-user-and-date";




  //   CineMarathi
  static const clientLogin = "auth/login";
  static const getDashboard = "users/dashboard";
  static const talentCategories = "users/talent/categories";
  
  // Upload endpoints
  static const uploadProfileImage = "upload/profile";
  static const uploadFile = "upload/file";
  
  // Portfolio endpoints
  static const getPortfolioImages = "portfolio/images";
  static const uploadSinglePortfolioImage = "portfolio/image"; // POST single image
  static const uploadPortfolioImages = "portfolio/images"; // POST multiple images
  static const updatePortfolioImage = "portfolio/images"; // PUT with index
  static const deletePortfolioImage = "portfolio/images"; // DELETE with index
  static const clearPortfolioImages = "portfolio/images"; // DELETE all
  
  // Profile endpoints
  static const updateProfile = "users/profile";
  
  // Casting Calls endpoints
  static const getCastingCalls = "casting/calls";
  static const getCastingCallById = "casting/calls"; // GET /casting/calls/:id
  static const getMyCastingCalls = "casting/calls/my";
  static const createCastingCall = "casting/calls";
  static const updateCastingCall = "casting/calls"; // PUT /casting/calls/:id
  static const deleteCastingCall = "casting/calls"; // DELETE /casting/calls/:id
  static const getCastingCallApplications = "casting/calls"; // GET /casting/calls/:id/applications
  static const updateApplicationStatus = "casting/applications"; // PUT /casting/applications/:id/status
  static const applyToCastingCall = "casting/apply";
  static const getMyApplications = "casting/applications/my";
  static const searchCastingCalls = "search/casting-calls";
  
}
