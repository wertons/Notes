package notes.model;

public class User {
    String name;
    String passhash;

    public User() {
    }

    public User(String name, String passhash) {
        this.name = name;
        this.passhash = passhash;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPasshash() {
        return passhash;
    }

    public void setPasshash(String passhash) {
        this.passhash = passhash;
    }

    public boolean compare(User usr) {
        if (this.getName().equals(usr.getName()) && this.getPasshash().equals(usr.getPasshash())) {
            return true;
        } else {
            return false;
        }
    }


}
