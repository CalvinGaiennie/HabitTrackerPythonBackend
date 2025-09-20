# from fastapi import FastAPI, Request
# from fastapi.middleware.cors import CORSMiddleware
# from plaid.api import plaid_api
# from plaid import Configuration, Environment, ApiClient
# from plaid.model.link_token_create_request import LinkTokenCreateRequest
# from plaid.model.link_token_create_request_user import LinkTokenCreateRequestUser
# from plaid.model.products import Products
# from plaid.model.country_code import CountryCode
# from plaid.model.item_public_token_exchange_request import ItemPublicTokenExchangeRequest
# from plaid.model.transactions_get_request import TransactionsGetRequest
# from plaid.exceptions import ApiException
from datetime import date, timedelta
import os
from dotenv import load_dotenv
import time

load_dotenv()

app = FastAPI()

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # loosened for dev
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

def init_db():
    conn = psycopg2.connect(os.environ["DATABASE_URL"])
    cur = conn.cursor()

    with open("dbschema.sql", "r") as f:
        schema_sql = f.read()
        cur.execute(schema_sql)

    conn.commit()
    cur.close()
    conn.close()

if __name__ == "__main__":
    init_db()

# Plaid config
# configuration = Configuration(
#     # host=Environment.Production, 
#     host=Environment.Sandbox,
#     api_key={
#         "clientId": os.getenv("PLAID_CLIENT_ID"),
#         "secret": os.getenv("PLAID_SECRET"),
#     }
# )
# api_client = ApiClient(configuration)
# client = plaid_api.PlaidApi(api_client)

# ACCESS_TOKENS = {}

# # Create Link Token
# @app.get("/create_link_token")
# def create_link_token():
#     request = LinkTokenCreateRequest(
#         user=LinkTokenCreateRequestUser(client_user_id="user-123"),
#         client_name="My Finance App",
#         products=[Products("transactions")],
#         country_codes=[CountryCode("US")],
#         language="en",
#     )
#     response = client.link_token_create(request)
#     return {"link_token": response.link_token}

# # Exchange Public Token for Access Token
# @app.post("/exchange_token")
# async def exchange_token(request: Request):
#     body = await request.json()
#     public_token = body.get("public_token")
#     exchange_request = ItemPublicTokenExchangeRequest(public_token=public_token)
#     exchange_response = client.item_public_token_exchange(exchange_request)
#     access_token = exchange_response.access_token
#     ACCESS_TOKENS["user-123"] = access_token
#     return {"access_token": access_token}

# # Fetch Transactions (with retry for PRODUCT_NOT_READY)
# @app.get("/transactions")
# def get_transactions():
#     access_token = ACCESS_TOKENS.get("user-123")
#     if not access_token:
#         return {"error": "No access token saved"}

#     start_date = date.today() - timedelta(days=365)
#     end_date = date.today()

#     request = TransactionsGetRequest(
#         access_token=access_token,
#         start_date=start_date,
#         end_date=end_date
#     )
#     response = client.transactions_get(request)
#     print("Plaid transactions response:", response.to_dict())  # debug log
#     return {"transactions": response["transactions"]}


# @app.get("/")
# def hello():
#     return {"message": "Hello Worlddd"}
