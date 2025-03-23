from flask import Flask, request, jsonify

# Initialize Flask app
app = Flask(__name__)

# In-memory storage
devices = {}         # Store device details
device_counter = 1   # Counter for generating device IDs
users = {}           # Store mobile number to user ID mapping
user_counter = 1     # Counter for generating user IDs
emails = set()       # Store registered emails

# 1. Device Registration Endpoint
@app.route('/api/v2/user/device/add', methods=['POST'])
def add_device():
    global device_counter
    data = request.json  # Expecting device details in JSON
    # Generate a unique device ID
    new_device_id = f"device_{device_counter}"
    device_counter += 1
    # Store device details
    devices[new_device_id] = data
    return jsonify({
        "status": 1,
        "data": {
            "message": "Successfully Added",
            "deviceId": new_device_id
        }
    })

# 2. OTP Request Endpoint
@app.route('/api/v2/user/otp', methods=['POST'])
def request_otp():
    global user_counter
    data = request.json
    mobile_number = data['mobileNumber']
    device_id = data['deviceId']
    # Check if user exists, otherwise create a new one
    if mobile_number in users:
        user_id = users[mobile_number]
    else:
        user_id = f"user_{user_counter}"
        user_counter += 1
        users[mobile_number] = user_id
    # Simulate OTP sending (in reality, this would send an OTP)
    return jsonify({
        "status": 1,
        "data": {
            "message": "OTP sent successfully",
            "userId": user_id,
            "deviceId": device_id
        }
    })

# 3. OTP Verification Endpoint
@app.route('/api/v2/user/otp/verification', methods=['POST'])
def verify_otp():
    data = request.json
    otp = data['otp']
    # Simulate OTP verification (accept any OTP for this example)
    return jsonify({
        "otp": f"{otp} accepted",
        "Access": "Granted"
    })

# 4. Email Referral/Registration Endpoint
@app.route('/api/v2/user/email/referral', methods=['POST'])
def email_referral():
    data = request.json
    email = data['email']
    # Check if email already exists
    if email in emails:
        return jsonify({
            "status": 0,
            "data": {
                "message": "Email exists"
            }
        })
    else:
        emails.add(email)  # Register the new email
        return jsonify({
            "status": 1,
            "data": {
                "message": "Email added successfully"
            }
        })

# 5. Home Page Data Endpoint
@app.route('/api/v2/user/home/withoutPrice', methods=['POST'])
def home_without_price():
    # Return static home page data
    return jsonify({
        "status": 1,
        "data": {
            "banner_one": [
                {"banner": "http://devapiv4.dealsdray.com/icons/banner.png"},
                {"banner": "http://devapiv4.dealsdray.com/icons/banner.png"}
            ],
            "category": [
                {"label": "Mobile", "icon": "http://devapiv4.dealsdray.com/icons/cat_mobile.png"},
                {"label": "Laptop", "icon": "http://devapiv4.dealsdray.com/icons/cat_lap.png"},
                {"label": "Camera", "icon": "http://devapiv4.dealsdray.com/icons/cat_camera.png"},
                {"label": "LED", "icon": "http://devapiv4.dealsdray.com/icons/cat_led.png"}
            ],
            "products": [
                {"icon": "http://devapiv4.dealsdray.com/icons/Image -75.png", "offer": "36%", "label": "FINICKY-WORLD V380", "SubLabel": "Wireless HD IP Security"},
                {"icon": "http://devapiv4.dealsdray.com/icons/Image -79.png", "offer": "32%", "label": "MI LED TV 4A PRO 108 CM", "Sublabel": "(43) Full HD Android TV"},
                {"icon": "http://devapiv4.dealsdray.com/icons/Image -76.png", "offer": "12%", "label": "HP 245 7th GEN AMD", "Sublabel": "(4GB/1TB/DOS)G6"},
                {"icon": "http://devapiv4.dealsdray.com/icons/Image -80.png", "offer": "45%", "label": "MI Redmi 5 (Blue,4GB)", "Sublabel": "RAM,64GB Storage"}
            ],
            "banner_two": [{"banner": "http://devapiv4.dealsdray.com/icons/discount_banner.png"}],
            "new_arrivals": [
                {"icon": "http://devapiv4.dealsdray.com/icons/Image 4.png", "offer": "21%", "brandIcon": "http://devapiv4.dealsdray.com/icons/Image -107.png", "label": "Realme 2 Pro(Black,Sea,64 GB)"},
                {"icon": "http://devapiv4.dealsdray.com/icons/Image -41.png", "offer": "21%", "brandIcon": "http://devapiv4.dealsdray.com/icons/Image -107.png", "label": "Realme 3i (Diamond Red,64 GB) (4 GB...)"}
            ],
            "banner_three": [
                {"banner": "http://devapiv4.dealsdray.com/icons/Image -97.png"},
                {"banner": "http://devapiv4.dealsdray.com/icons/Image -99.png"}
            ],
            "categories_listing": [
                {"icon": "http://devapiv4.dealsdray.com/icons/Image -70.png", "offer": "32%", "label": "Nokia 8.1(iron,64 GB)"},
                {"icon": "http://devapiv4.dealsdray.com/icons/Image 7.png", "offer": "14%", "label": "Redmin Note 7s (Sapphire Blue 64 GB)"}
            ],
            "top_brands": [{"icon": "http://devapiv4.dealsdray.com/icons/brand_bg.png"}],
            "brand_listing": [
                {"icon": "http://devapiv4.dealsdray.com/icons/Image 4.png", "offer": "21%", "brandIcon": "http://devapiv4.dealsdray.com/icons/Image -107.png", "label": "Realme 2 Pro(Black,Sea,64 GB)"},
                {"icon": "http://devapiv4.dealsdray.com/icons/Image -41.png", "offer": "21%", "brandIcon": "http://devapiv4.dealsdray.com/icons/Image -107.png", "label": "Realme 3i (Diamond Red,64 GB) (4 GB...)"}
            ],
            "top_selling_products": [
                {"icon": "http://devapiv4.dealsdray.com/icons/Image 26.png", "label": "Moniters"},
                {"icon": "http://devapiv4.dealsdray.com/icons/Image 27.png", "label": "Printers"},
                {"icon": "http://devapiv4.dealsdray.com/icons/Image 28.png", "label": "Cameras"},
                {"icon": "http://devapiv4.dealsdray.com/icons/Image 29.png", "label": "LED Bulb"}
            ],
            "featured_laptop": [
                {"icon": "http://devapiv4.dealsdray.com/icons/Image -133.png", "brandIcon": "http://devapiv4.dealsdray.com/icons/Image -132.png", "label": "Apple MacBook Air Core i5th Gen - (8 GB/128 GB SSD/Mac OS...)", "price": "284,999"},
                {"icon": "http://devapiv4.dealsdray.com/icons/Image 23.png", "brandIcon": "http://devapiv4.dealsdray.com/icons/Image -33.png", "label": "HP 14G APU Dual Core A6 -(4 GB/256 GB SSD/WINDOWS 10)...", "price": "284,999"}
            ],
            "upcoming_laptops": [
                {"icon": "http://devapiv4.dealsdray.com/icons/great_deals.png"},
                {"icon": "http://devapiv4.dealsdray.com/icons/Image -124.png"},
                {"icon": "http://devapiv4.dealsdray.com/icons/Image -125.png"}
            ],
            "unboxed_deals": [
                {"icon": "http://devapiv4.dealsdray.com/icons/Image -70.png", "offer": "32%", "label": "Nokia 8.1(iron,64 GB)"},
                {"icon": "http://devapiv4.dealsdray.com/icons/Image 7.png", "offer": "14%", "label": "Redmin Note 7s (Sapphire Blue 64 GB)"}
            ],
            "my_browsing_history": [
                {"icon": "http://devapiv4.dealsdray.com/icons/Image 4.png", "offer": "21%", "brandIcon": "http://devapiv4.dealsdray.com/icons/Image -107.png", "label": "Realme 2 Pro(Black,Sea,64 GB)"},
                {"icon": "http://devapiv4.dealsdray.com/icons/Image -41.png", "offer": "21%", "brandIcon": "http://devapiv4.dealsdray.com/icons/Image -107.png", "label": "Realme 3i (Diamond Red,64 GB) (4 GB...)"}
            ]
        }
    })

# Run the Flask app
if __name__ == '__main__':
    app.run(debug=True)