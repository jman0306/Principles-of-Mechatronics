extern "C" {
  void START();  // Declare the assembly function you want to call
}
void setup() {
  START();
}
void loop() {
  START();  // Call the assembly function 
}
