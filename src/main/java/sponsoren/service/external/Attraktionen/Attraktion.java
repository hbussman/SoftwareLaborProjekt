package sponsoren.service.external.Attraktionen;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class Attraktion
{
    private String headerImage;

    private String latitude;

    private String name;

    private String description;

    private String openingHours;

    private String id;

    private String userId;

    private User user;

    private String longitude;

    public String getHeaderImage ()
    {
        return headerImage;
    }

    public void setHeaderImage (String headerImage)
    {
        this.headerImage = headerImage;
    }

    public String getLatitude ()
    {
        return latitude;
    }

    public void setLatitude (String latitude)
    {
        this.latitude = latitude;
    }

    public String getName ()
    {
        return name;
    }

    public void setName (String name)
    {
        this.name = name;
    }

    public String getDescription ()
    {
        return description;
    }

    public void setDescription (String description)
    {
        this.description = description;
    }

    public String getOpeningHours ()
    {
        return openingHours;
    }

    public void setOpeningHours (String openingHours)
    {
        this.openingHours = openingHours;
    }

    public String getId ()
    {
        return id;
    }

    public void setId (String id)
    {
        this.id = id;
    }

    public String getUserId ()
    {
        return userId;
    }

    public void setUserId (String userId)
    {
        this.userId = userId;
    }

    public User getUser ()
    {
        return user;
    }

    public void setUser (User user)
    {
        this.user = user;
    }

    public String getLongitude ()
    {
        return longitude;
    }

    public void setLongitude (String longitude)
    {
        this.longitude = longitude;
    }

    @Override
    public String toString()
    {
        return "ClassPojo [headerImage = "+headerImage+", latitude = "+latitude+", name = "+name+", description = "+description+", openingHours = "+openingHours+", id = "+id+", userId = "+userId+", user = "+user+", longitude = "+longitude+"]";
    }
}
