# Understand cc statement

This app will read the cc statement pdf file and then group and sum the expenses based on the business.

To run this would need to pass in the following format

1. Create the virtual environment

```
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

2. To execute you can run in the following format.

```
python read_credit_card_statement.py --filename <credit card pdf file> --password "mypassword"
```
