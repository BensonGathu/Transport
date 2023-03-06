class User {
  final String first_name;
  final String last_name;
  final String email;
  final String password;
  final String phone_number;

  const User({
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.password,
    required this.phone_number,
  });

  Map<String, dynamic> toJson() => {
        "first_name": first_name,
        "last_name": last_name, 
        "email": email,
        "password": password,
        "phone_number":phone_number
       
      };
    
    
       
}
