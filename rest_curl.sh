#!/bin/sh
<< COMMENT
curl -X POST https://api.sandbox.paypal.com/v1/identity/openidconnect/tokenservice \
  -H 'authorization: Basic <BASE64 encoded (ClientID:Secret)>' \
  -H 'content-type: application/x-www-form-urlencoded' \
  -d 'grant_type=refresh_token&refresh_token={"token_type": "Bearer", "expires_in": "28800", "access_token": "<AccessToken>"}'
COMMENT

<< COMMENT2
curl -v https://api.sandbox.paypal.com/v1/invoicing/invoices/ \
  -H "Content-Type: application/json" \
  -H "PayPal-Partner-Attribution-Id: BENZOOKAPI" \
  -H "Authorization: Bearer <AccessToken>" \
  -d '{
  "merchant_info": {
  "email": "xxxxxxxxxxx@xxxxxxx.com",
  "first_name": "Dennis",
  "last_name": "Doctor",
  "business_name": "Medical Professionals, LLC",
  "phone": {
    "country_code": "001",
    "national_number": "5032141716"
  },
  "address": {
    "line1": "1234 Main St.",
    "city": "Portland",
    "state": "OR",
    "postal_code": "97217",
    "country_code": "US"
  }
  },
  "billing_info": [
  {
    "email": "xxxxxxxxxxx@xxxxxxx.com"
  }
  ],
  "items": [
  {
    "name": "Sutures",
    "quantity": 1,
    "unit_price": {
    "currency": "USD",
    "value": "1"
    }
  }
  ],
  "note": "Medical Invoice 16 Jul, 2013 PST",
  "payment_term": {
  "term_type": "NET_45"
  },
  "shipping_info": {
  "first_name": "Sally",
  "last_name": "Patient",
  "business_name": "Not applicable",
  "phone": {
    "country_code": "001",
    "national_number": "5039871234"
  },
  "address": {
    "line1": "1234 Broad St.",
    "city": "Portland",
    "state": "OR",
    "postal_code": "97216",
    "country_code": "US"
  }
  }
}'
COMMENT2

<< COMMENT3
curl -v -X POST https://api.sandbox.paypal.com/v1/invoicing/invoices/INV2-YDZV-6D4N-U8RT-2FJM/send \
-H "Content-Type:application/json" \
-H "Authorization: Bearer <AccessToken>"
COMMENT3

<< COMMENT4
curl -v -X GET https://api.sandbox.paypal.com/v1/invoicing/invoices/INV2-YDZV-6D4N-U8RT-2FJM \
-H "Content-Type:application/json" \
-H "Authorization: Bearer <AccessToken>"
COMMENT4

<< COMMENT5
curl -v -X POST https://api.sandbox.paypal.com/v1/payments/sale/9UE72607U0576013F/refund \
-H "Content-Type:application/json" \
-H "Authorization: Bearer <AccessToken>" \
-d '{
  "amount": {
  "total": "1",
  "currency": "USD"
  },
  "invoice_number": "INV-1234567"
}'
COMMENT5
