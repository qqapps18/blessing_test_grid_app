package com.qqapps.blessingbook.HebrewDate;

/**
This exception is thrown to indicate a problem with 
calculating sunruse.sunset times, for example
the sun does not set at certain locations at certain 
times of the year.

(c)2001 Kevin Boone/Web-Tomorrow, all rights reserved
*/
class SunTimesException extends Exception {
/**
	 * 
	 */
	private static final long serialVersionUID = -6679424439309121412L;

	public SunTimesException()
  {
  super ("Problem calculating sunrise/sunset times");
  } 

public SunTimesException (String s)
  {
  super (s);
  } 
}
