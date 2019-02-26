# Sorghum Yield App

The Sorghum app aims to help farmers generate and store reports containing predictions on the yield of their sorghum fields. Users can input both photos and information about their fields, which are then analyzed within the app to calculate a yield prediction. Each report contains information regarding farm measurements, plant photos, and geological locations. This information will help K-State researchers and farmers alike.  

## Technologies & Tool Used

- Objective-C
- Google Firebase  
- Xcode

## Installation

Download the project 

```bash
git clone git@github.com:katbrown97/SorghumYield.git
```
Double click **SorghumYield.xcworkspace** to trigger Xcode or simply open the the project in Xcode.

## Get Started

For this section, we will explain what each controller's role is to help you get a general impression of how the app functions.

**PhotoPickerViewController**
This controller is reponsible for taking photos from both camera and gallery and processing the images.

**ResultViewController**
This controller is responsible for displaying the yield estimation results. 

When the "Submit" button is clicked, it saves the information to Firebase. It first stores the entered data, metadata, image links, and results to a report in the Cloud Firestore Database. Then it saves the images themselves to a folder within Firebase Storage. Additionally, the user's "reports" field is updated. If the user is submitting their first report, then this is also responsible for adding them to the database.

## License
[MIT](https://choosealicense.com/licenses/mit/)
