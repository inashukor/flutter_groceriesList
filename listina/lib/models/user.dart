class User{
  String state;
  bool admin;

  User(this.state);

  Map<String, dynamic>toJson()=>{
    'state':state,
    'admin':admin,
  };
}