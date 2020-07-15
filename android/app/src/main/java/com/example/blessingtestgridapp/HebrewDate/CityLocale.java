package com.example.blessingtestgridapp.HebrewDate;import java.util.TimeZone;/*** This class defines a city and its location on the planet.<BR>* A city has certain co-ordinates on the planet expressed by its latitude* and longitude. A city also has a time zone that it exists in.* @see TimeZone* @see CityLocaleList*/public class CityLocale{	private String name;	private String key= "default";	private double longitude;	private double latitude;	private TimeZone timeZone;	public CityLocale (String key, String name, double latitude, double longitude, TimeZone timeZone)	{		setKey(key);		setName(name);		setLatitude(latitude);		setLongitude(longitude);		setTimeZone(timeZone);	}	public CityLocale()	{	}	/** Gets the full name for this city.	* @return The fulle name or the key if no name is defined.	*/	public String getName()	{		if (name == null)			return key;		else			return name;	}	/** Gets the key for this city. */	public String getKey()	{		return key;	}	/** Gets the longitude of this city (East is +/West is -). */	public double getLongitude()	{		return longitude;	}	/** Gets the latitude of this city (North is +/South is -). */	public double getLatitude()	{		return latitude;	}	/** Gets the TimeZone for this city.     * @return The TimeZone that this city is set to, otherwise,     * it returns the default TimeZone.     */	public TimeZone getTimeZone()	{		if (timeZone != null)			return timeZone;		else			return TimeZone.getDefault();	}	/** Sets the full name for this city. */    private void setName(String name)	{		this.name= name;	}	/** Sets the unique key for this city.<P>	* Usually, this is a short form version of its name.	*/    private void setKey(String key)	{		this.key= key;	}	/** Sets the longitude of this city (East is +/West is -). */    private void setLongitude(double longitude)	{		this.longitude= longitude;	}	/** Sets the latitude of this city (North is +/South is -). */    private void setLatitude(double latitude)	{		this.latitude= latitude;	}	/** Sets the TimeZone for this city. */    private void setTimeZone(TimeZone timeZone)	{		this.timeZone= timeZone;	}	/**     * Sets the TimeZone using a String that is this time zone's id.     * @param zoneID The TimeZone ID string.     * @see TimeZone     */	public void setTimeZoneID(String zoneID)	{		this.timeZone= TimeZone.getTimeZone(zoneID);	}    /**     * Gets the TimeZone's ID.     * @return the Time Zone ID String.     */    public String getTimeZoneID()    {        return timeZone.getID();    }}