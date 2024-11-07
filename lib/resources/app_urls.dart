class AppUrls {
  static const baseUrl = 'https://globtechnoitsolution.com:8443/electioncount';
  static const sendOtp = '$baseUrl/api/auth/customer/send-otp/';
  static const verifyOtp = '$baseUrl/api/auth/signin';
  static const signUp = '$baseUrl/api/auth/committee/signup';
  static const getVoterData = '$baseUrl/voterlist/get/totalcount';
  static const getVoters = '$baseUrl/voterlist/all-by-pagination';
  static const updateVoted = '$baseUrl/voterlist/set/voted/';
}
