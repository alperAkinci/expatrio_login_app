# Flutter Login App

A Flutter application using Expatrio API implements a login page, a screen with
a Call-to-Action (CTA) to update tax data, and a bottom sheet for inputting and editing tax data.

## credentials for access 
- email : tito+bs792@expatrio.com
- password : nemampojma

## features
- Login Page
  - Authentication via http package
  - Showing error message if API call fails
  - Showing success page with ModalBottomSheet if API call succeed
  - Validation for handling empty email/password TextFormFields
  - Usage of lottie asset
- Tax Data Page
  - Pre-populating existing fields with data received from the API
  - Allowing the user to select country using DropdownSearch
  - Disallow the user to select previously selected country
  - Allowing the user to input a TAX ID number using TextFormField
  - A user can select secondary taxation countries by clicking the ADD ANOTHER button
  - A user can delete additional countries by clicking on the REMOVE button
  - A user must be forced to check a checkbox before being able save their tax data via SAVE button.
## notes
 - The maximum secondary taxation country is limited to 3 to avoid over-addition
 - Currently empty country and taxID is allowed for secondary tax residences

## setup
* Use the command (pull the project): $ git clone https://github.com/alperAkinci/expatrio_login_app.git
* Then command (get dependencies): $ flutter packages get
* Final command (run): $ flutter run

 

  
  
  


