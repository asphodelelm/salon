#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ Salon ~~~~~\n"

#display list of offered services
#input prompt to choose service
#if picked service doesnt exist, show list again
#prompt users to enter a service_id, var SERVICE_ID_SELECTED 
#prompt users to enter phone number, var CUSTOMER_PHONE
  #if customer doesnt exist
  #get customer name, var CUSTOMER_NAME
  #insert new customer into customers table
#prompt users to enter time, var SERVICE_TIME
#after an appointment is successfully added, output message "I have put you down for a <service> at <time>, <name>."

SERVICES_MENU() {
  #get available services
  SERVICES_OFFERED=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")

    #display available services
    echo -e "\nHere are the services we have available:"
    
    echo "$SERVICES_OFFERED" | while read SERVICE_ID BAR SERVICE
    do
      echo "$SERVICE_ID) $SERVICE"
    done


    echo -e "\nWhich service would you like to choose?"
    read SERVICE_ID_SELECTED

    if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
    then
 
     SERVICES_MENU "That is not a valid service number."
    else
        #get customer info
        echo -e "\nWhat's your phone number?"
        read CUSTOMER_PHONE
        CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

        #if customer doesn't exist
        if [[ -z $CUSTOMER_NAME ]]
        then
          #get new customer name
          echo -e "\nWhat's your name?"
          read CUSTOMER_NAME

          #insert new customer        
          INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
        fi

      #get customer_id
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

    #ask for time 
     echo -e "\nWhat time do you want your appointment?"
     read SERVICE_TIME

      # insert appointment
      INSERT_RENTAL_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME')")
      

      #success output
      SERVICE_SELECTED=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
      echo "I have put you down for a $SERVICE_SELECTED at $SERVICE_TIME, $CUSTOMER_NAME."
      
      fi

  
}

SERVICES_MENU
