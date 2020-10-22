package com.cs336proj.root;

import java.sql.SQLException;
import java.util.regex.Pattern;

public class Validation {
	public static void checkAddress(String Address) throws SQLException {
			if(!Address.matches("^\\d+\\s[A-z]+\\s[A-z]+\\.*")) {
				throw new SQLException("Address invalid.  Please enter an address of the form: [St. #] [St. name] [St. Suffix]");
			}
	}
	public static void checkEmail(String email) throws SQLException {
		if(!Pattern.compile("^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,6}$", Pattern.CASE_INSENSITIVE).matcher(email).find()) {
			throw new SQLException("Email invalid.");
		}
	}
	public static void checkName (String fName, String lName) throws SQLException {
		if(!Pattern.matches("[a-zA-z]+", fName)) {
			throw new SQLException("Invalid First Name Input");
		} else if(!Pattern.matches("[a-zA-z]+", lName)) {
			throw new SQLException("Invalid Last Name Input");
		}
	}
	public static void checkZipCode(String zip) throws SQLException {
		if(!Pattern.matches("[0-9]+", zip)) {
			throw new SQLException("Invalid Zipcode Input. You entered something that was not a number");
		}
	}
	public static void checkState(String state) throws SQLException {
		if(!Pattern.matches("[a-zA-z]+", state)) {
			throw new SQLException("Invalid input for State");
		}
	}
	public static void checkCity(String city) throws SQLException{
		if(!Pattern.matches("[a-zA-Z]+(?:[.]*[ '-][a-zA-Z]+)*", city)) {
			throw new SQLException("Invalid City Input");
		}
	}
	public static void checkPhoneNumber(String phone) throws SQLException {
		if(!Pattern.matches("[0-9]+", phone)) {
			throw new SQLException("Invalid Phone Number Input. You entered something that was not a number");
		}
	}
	public static void checkLength(String Address, String email, String fName, String lName, String zip, String state, String city, String phone, String username, String password) throws SQLException {
		if(Address.length() < 1 || email.length() < 1 || fName.length() < 1 || lName.length() < 1 || zip.length()<1 || state.length() < 1 || city.length()<1 || phone.length()<1 || username.length() <1 || password.length()<1) {
			throw new SQLException("Your input needs to be greater than one character");
		}
	}
	
}