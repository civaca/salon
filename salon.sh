#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=salon -t -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU(){

#MENU MESSAgGE
if [[ $1 ]]
then 
echo -e "\n$1"
fi


#LIST OF SERVICES AVAIALBALE
EXAMPLE=$($PSQL "SELECT * FROM services")
echo "$EXAMPLE" | while read SERVICE_ID BAR SERVICE_NAME
do
echo "$SERVICE_ID) $SERVICE_NAME"
done
read SERVICE_ID_SELECTED

MENU_SELECTED=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED' ")

#SELECTED MENU
if [[ -z $MENU_SELECTED ]]
then 
  MAIN_MENU "I could not find that service. What would you like today?"
else 
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
#NAME
  if [[ -z $CUSTOMER_NAME ]]
then 
  echo -e "\nI don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME
  #INSERT NEW CUSTOMER
 $($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
  fi # of customer name

#FORMATTED VALUES
  MENU_SELECTED_FORMATTED=$(echo $MENU_SELECTED | sed -r 's/^ *| *$//g')
  CUSTOMER_NAME_FORMATTED=$(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')
  echo -e "\nWhat time would you like your $MENU_SELECTED_FORMATTED, $CUSTOMER_NAME_FORMATTED?"
read SERVICE_TIME

CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
#INSERT APPOINTMENTS
INSERTED_APPOINTMENTS=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES ('$CUSTOMER_ID','$SERVICE_ID_SELECTED','$SERVICE_TIME')")

#FORMATTED VALUES 
SERVICE_TIME_FORMATTED=$(echo $SERVICE_TIME | sed -r 's/^ *| *$//g')

echo -e "\nI have put you down for a $MENU_SELECTED_FORMATTED at $SERVICE_TIME_FORMATTED, $CUSTOMER_NAME_FORMATTED."
fi # of menu selected
}

MAIN_MENU "Welcome to My Salon, how can I help you?\n"