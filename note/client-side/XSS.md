Simply change the action which use can do. Use `alert()` or `print()` function for PoC.
Three main type of attack:
- Reflected XSS: Come from current HTTP request.
- Stored XSS: Come from website databases.
- DOM-Based XSS: The vulnerability is from client-side of app not server-side.

### What can XSS attack do? 
You can read any data which user can read from the web page, so you can steal credentials from user. Also inject trojan and deface the target website.

### Prevent XSS Attack
- Filter input
- Encode data on output
- Use response header
- Content security policy (CSP)

---
### Reflected XSS
Impacts:
- View any information that the user can view
- Modify ant information that the user can modify 
- Perform any action within the application that the user can perform

#### How to Find Reflected XSS Attack?
- Test Every entity point
- Submit random values
- Test payload
- Test the attack in the browser 

### Stored XSS
How to find one?
- **Parameters** or other data within the URL query string and message body
- The URL file path
- HTTP request headers that might not be exploitable in relation to reflected XSS
- Any out-of-band routes
- Data submitted to any entry point could in principle be emitted from any exit point