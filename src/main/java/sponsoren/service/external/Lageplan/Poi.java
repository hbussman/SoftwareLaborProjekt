package sponsoren.service.external.Lageplan;

public class Poi
{
    private String CategoryID;

    private String AdminID;

    private String Description;

    private String Latitude;

    private String ID;

    private String WheelchairAccessible;

    private String type;

    private String Longitude;

    private String Link;

    private String GroupID;

    private String Name;

    public String getCategoryID ()
    {
        return CategoryID;
    }

    public void setCategoryID (String CategoryID)
    {
        this.CategoryID = CategoryID;
    }

    public String getAdminID ()
    {
        return AdminID;
    }

    public void setAdminID (String AdminID)
    {
        this.AdminID = AdminID;
    }

    public String getDescription ()
    {
        return Description;
    }

    public void setDescription (String Description)
    {
        this.Description = Description;
    }

    public String getLatitude ()
    {
        return Latitude;
    }

    public void setLatitude (String Latitude)
    {
        this.Latitude = Latitude;
    }

    public String getID ()
    {
        return ID;
    }

    public void setID (String ID)
    {
        this.ID = ID;
    }

    public String getWheelchairAccessible ()
    {
        return WheelchairAccessible;
    }

    public void setWheelchairAccessible (String WheelchairAccessible)
    {
        this.WheelchairAccessible = WheelchairAccessible;
    }

    public String getType ()
{
    return type;
}

    public void setType (String type)
    {
        this.type = type;
    }

    public String getLongitude ()
    {
        return Longitude;
    }

    public void setLongitude (String Longitude)
    {
        this.Longitude = Longitude;
    }

    public String getLink ()
    {
        return Link;
    }

    public void setLink (String Link)
    {
        this.Link = Link;
    }

    public String getGroupID ()
    {
        return GroupID;
    }

    public void setGroupID (String GroupID)
    {
        this.GroupID = GroupID;
    }

    public String getName ()
    {
        return Name;
    }

    public void setName (String Name)
    {
        this.Name = Name;
    }

    @Override
    public String toString()
    {
        return "ClassPojo [CategoryID = "+CategoryID+", AdminID = "+AdminID+", Description = "+Description+", Latitude = "+Latitude+", ID = "+ID+", WheelchairAccessible = "+WheelchairAccessible+", 4 = "+type+", Longitude = "+Longitude+", Link = "+Link+", GroupID = "+GroupID+", Name = "+Name+"]";
    }
}
