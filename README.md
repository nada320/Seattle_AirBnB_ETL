# Seattle_AirBnB_ETL
AirBnb is an online marketplace for providing lodging, primarily b&amp;b (bed and breakfast). The company does not own any of the listings on the application; it acts as a broker and receives commissions from each booking. Started in 2008, the company is based in San Francisco, California, US

## Data Source
Kaggle: https://www.kaggle.com/airbnb/seattle

1. Extract
The Extract phase involves retrieving raw data from various sources. For Seattle AirBnB data, the data can come from multiple sources such as:

     AirBnB Listings: CSV files containing information about AirBnB listings (e.g., listing details, host information, reviews, availability).
   
![image](https://github.com/user-attachments/assets/ce32c782-fce1-48f8-963a-dfdd02dc068a)

listing_df = listings_df[["id",'name',"street","neighbourhood_cleansed","neighbourhood_group_cleansed","city","state","zipcode","latitude","longitude","is_location_exact","property_type","room_type","accommodates","bathrooms","bedrooms","beds","bed_type","square_feet","price","weekly_price","monthly_price","security_deposit","cleaning_fee","guests_included","extra_people","minimum_nights","maximum_nights","has_availability","availability_30","availability_60","availability_90","availability_365","number_of_reviews","first_review","last_review","review_scores_rating","review_scores_accuracy","review_scores_cleanliness","review_scores_checkin","review_scores_communication","review_scores_location","review_scores_value","requires_license","instant_bookable","cancellation_policy","require_guest_profile_picture","require_guest_phone_verification","reviews_per_month","host_id"]].copy()
host_df = listings_df[["host_id","host_name","host_since","host_location","host_response_time","host_response_rate","host_acceptance_rate","host_is_superhost","host_neighbourhood","host_listings_count","host_has_profile_pic","host_identity_verified"]].copy()

2. Transform
The Transform phase involves cleaning, transforming, and enriching the raw data to make it suitable for analysis and reporting.

Tasks in the Transform Phase:
Data Cleaning:

Handle Missing Values: Fill or drop missing values.
Data Type Conversion: Convert data types as needed.
Remove Duplicates: Ensure there are no duplicate records





