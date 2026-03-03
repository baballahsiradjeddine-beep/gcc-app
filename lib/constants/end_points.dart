class EndPoints {
  static const login = '/v1/auth/login';
  static const register = '/v1/auth/register';
  // static const userInfo = '/v1/auth/user';

  // check email and verify
  static const checkPhoneNumberExists = '/v1/auth/check-phone-number';
  static const checkEmailExists = '/v1/auth/check-email';
  static const sendOtpCode = '/v1/email/send-verification-mail';
  static const verifyOtpCode = '/v1/email/verify-otp';

//user
  static const getUser = '/v1/user';
  static const updateUser = '/v1/user';
  // forget password
  static const forgotPassword = '/v1/forget-password';
  static const forgetPasswordverifyCode = '/v1/forget-password/verify-otp';
  static const resetPassword = '/v1/forget-password/reset-password';

  static const getData = '/v2/content';
  static const submitAnswers = '/v1/content/answer';

  //subscription
  static const subscribe = '/v1/subscriptions/redeem';
  static const subscriptions = '/subscriptions';

  // change password
  static const changePassword = '/v1/user/change-password';
  // divisions
  static const divisions = '/divisions';

  //change email
  static const changeEmail = '/v1/email/change';
  static const verifyEmail = '/v1/email/verify-change';

  static const leaderboard = '/v1/leaderboard';

  static const cards = '/v1/flashcards/content';
  static const resumes = '/v1/summaries/content';
  static const bacs = '/v1/bacs/content';
  static const banners = '/v1/banners';
  static const knowOptions = '/referral-sources';
  static const googleLogin = '/v1/auth/google/login';
  static const appAssets = '/v1/app-assets';
  static const googleRegister = '/v1/auth/google/register';
  static const sendVerifyEmailOtp = '/v1/email/send-verification-mail';
  static const verifyUser = '/v1/email/verify-email';
  static const notifications = '/v2/notifications';
  static const markNotificationAsRead = '/v2/notifications/mark-as-read';
  static const subscribeWithPaper = '/v2/purchase/initiate-manual-payment';
  static const subscribeWithChargily = '/v2/purchase/initiate-chargily';
  static const settings = '/v2/settings';
  static const streaks = '/v2/streaks';
  static const pingStreak = '/v2/streaks/ping';
  static const reportExercise = '/v2/reports/question';
  static const contactUs = '/v2/reports/contact';
  static const getTodayReview = '/v1/review/today';
  static const submitReview = '/v1/review/submit';
}
