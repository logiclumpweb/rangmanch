class Config {
  // iOS
  static String apiUrl = 'https://apis.argear.io';
  static const String BASE_PATH = '/storage/emulated/0/Download/';
  static const String OUTPUT_PATH = BASE_PATH + 'merge.mp4';
  // // iOS
  // static String  apiKey    = '18cc45cf018caf461ed53fcc';
  // static String  secretKey = 'e3f41733cfb04aeb1620db972e2093d68edf51c9862f66ba5bbc4eeb4176afde';
  // static String  authKey   = 'U2FsdGVkX1++tdP3QcXJp4RILPdE0WTJAu9zkC/kUkXZLJ0LwCIQN8Mqilz+Udh/wUumCYyo2f6HdbuXGFFLbg==';

  // // iOS com.app.addworld
  // static String  apiKey    = '60fbb44cbf53f04252d80a61';
  // static String  secretKey = '320d57b98c370b4dceb8cde570c6f1682322fc4d8d1aa2cfc9d330de99cb2c56';
  // static String  authKey   = 'U2FsdGVkX1+3yxB6xhVBprljp2k5TeymVra4p+7PVrpxrs64NJEQYzHUrZAeCUvPiFtxfoREvGwxeBeeIOmewQ==';

  // iOS com.apps.addworld Previous
/*  static String  apiKey    = '224cb14dd72689a299d14588';
  static String  secretKey = 'e1b7c53f7c3e9b67ebab40d29897ba343c94b95843e155715034d3b17f62c7d6';
  static String  authKey   = 'U2FsdGVkX19gLhyGNcqelbY/FHKn/BS5knwUYFP3tzgT6pznz2SbHpDpYmJzAqcNeknybbFpkix+i94B5gWNFg==';*/

  // // Android Live
  static String apiKey = '6f79a408ad3bf5ccf796a734';
  static String secretKey =
      'ee5fcffa5f5bed548ccf5db10adabea20f511f37ad378d50a99aac553bf25c43';
  static String authKey =
      'U2FsdGVkX1/Ubigitsw1qfUCmESepGT9mDLiYiEYtF+PgE2ieZqoqah2zoXzVQtPJAGi3ZsGybHLABu+cORMIA==';

  // // Android com.app.champcash.champcash
  // static String  apiKey    = '18cc45cf018caf461ed53fcc';
  // static String  secretKey = 'e3f41733cfb04aeb1620db972e2093d68edf51c9862f66ba5bbc4eeb4176afde';
  // static String  authKey   = 'U2FsdGVkX1+ZKYGmpKCwgjbFWGURKOuP8pfbgGrjxyyNlhSqBRumXr0jmTbXGmOo9VlcZd5vZIU+IIj5gfwZSA==';

  static List<double> BEAUTY_TYPE_INIT_VALUE = [
    10, //VLINE
    90, //ACE_SLIM
    55, //JAW
    -50, //CHIN
    5, //EYE
    -10, //EYE_GAP
    0, //NOSE_LINE
    35, //NOSE_SIDE
    30, //NOSE_LENGTH
    -35, //MOUTH_SIZE
    0, //EYE_BACK
    0, //EYE_CORNER
    0, //LIP_SIZE
    50, //SKIN
    0, //DARK_CIRCLE
    0, //MOUTH_WRINKLE
  ];
}
