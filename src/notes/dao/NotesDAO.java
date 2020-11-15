package notes.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.*;

import notes.model.*;

public class NotesDAO {
	public NotesDAO() {
	}

	public Connection createConnection() throws ClassNotFoundException {
		Class.forName("org.sqlite.JDBC");

		Connection connection = null;
		try {
			// create a database connection
			connection = DriverManager.getConnection("jdbc:sqlite:notes.db");
			connection.createStatement().execute("PRAGMA foreign_keys = ON");
		} catch (SQLException e) {
			// if the error message is "out of memory",
			// it probably means no database file is found
			System.err.println(e.getMessage());
		}
		return connection;
	}

	public void closeConnection(Connection connection) {
		try {
			if (connection != null)
				connection.close();
		} catch (SQLException e) {
			// connection close failed
			System.err.println(e);
		}
	}

	public boolean runQuery(String statementString) {
		Connection connection = null;

		try {
			connection = createConnection();
			Statement statement = connection.createStatement();
			statement.executeUpdate(statementString);

		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
			return false;

		} finally {
			closeConnection(connection);
		}
		return true;
	}

	public boolean insertUser(User usr) {
		String name = usr.getName();
		String passhash = usr.getPasshash();
		System.out.println("trying to insert user into db: "+name + passhash);
		return runQuery("INSERT INTO User (Name,Passhash) VALUES('" + name + "','" + passhash + "');");
	}

	public boolean insertNote(String owner, String title, String content) {

		return runQuery(
				"INSERT INTO Note (Owner,Title,Content) VALUES('" + owner + "','" + title + "','" + content + "');");
	}

	public boolean insertUsers_Access_Notes(String User, int ID) {
		return runQuery("INSERT INTO Users_Access_Notes (User,ID) VALUES('" + User + "','" + ID + "');");
	}

	public boolean checkUser(String name) {
		Connection connection = null;
		ResultSet rs = null;
		String query = "SELECT Name,PassHash FROM User WHERE Name = '" + name + "';";

		try {
			connection = createConnection();
			Statement statement = connection.createStatement();
			rs = statement.executeQuery(query);
			try {
				while (rs.next()) {
					String rsName = rs.getString("Name");

					return rsName.equals(name);
				}
			} catch (SQLException e) {
				e.printStackTrace();
				return false;
			}

		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
		} finally {
			closeConnection(connection);
		}
		return false;

	}

	public boolean checkNote(int id) {
		Connection connection = null;
		ResultSet rs = null;
		String query = "SELECT ID FROM Note WHERE ID = '" + id + "';";

		try {
			connection = createConnection();
			Statement statement = connection.createStatement();
			rs = statement.executeQuery(query);
			try {
				while (rs.next()) {
					int rsName = rs.getInt(id);
					return rsName == id;
				}
			} catch (SQLException e) {
				e.printStackTrace();
				return false;
			}

		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
		} finally {
			closeConnection(connection);
		}
		return false;

	}

	public boolean checkLogin(String name, String passhash) {
		User dbUser = getUser(name);
		if (dbUser.getPasshash().equals(passhash)) {
			return true;
		}
		return false;
	}

	public Note getNote(int id) {
		Note noteReturn = new Note();

		Connection connection = null;
		ResultSet rs = null;
		String query = "SELECT Owner,Title,Content FROM Note WHERE ID = '" + id + "';";

		try {
			connection = createConnection();
			Statement statement = connection.createStatement();
			rs = statement.executeQuery(query);
			try {
				while (rs.next()) {
					noteReturn.setId(id);
					noteReturn.setOwner(rs.getString("Owner"));
					noteReturn.setTitle(rs.getString("Title"));
					noteReturn.setBody(rs.getString("Content"));
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}

		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
		} finally {
			closeConnection(connection);
		}
		return noteReturn;
	}

	public Note[] getAllNotes() {
		List<Note> notes = new ArrayList<Note>();
		int counter = 1;
		boolean check = true;
		while (check) {
			Note note = getNote(counter);
			if (note.getId() == 0) {
				check = false;
				break;
			}
			notes.add(note);
			System.out.print(note.getId() + ":");
			System.out.print(" Owner: " + note.getOwner());
			System.out.print(" Title: " + note.getTitle());
			System.out.print(" Content: " + note.getBody());
			System.out.println();
			counter++;
		}

		return notes.toArray(new Note[notes.size()]);
	}

	public User getUser(String name) {
		User userReturn = new User();

		Connection connection = null;
		ResultSet rs = null;
		String query = "SELECT Name,Passhash FROM User WHERE Name = '" + name + "';";

		try {
			connection = createConnection();
			Statement statement = connection.createStatement();
			rs = statement.executeQuery(query);
			try {
				while (rs.next()) {
					userReturn.setName(name);
					userReturn.setPasshash(rs.getString("Passhash"));
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}

		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
		} finally {
			closeConnection(connection);
		}
		return userReturn;
	}

	public User[] getAllUsers() {
		List<User> userReturn = new ArrayList<User>();

		Connection connection = null;
		ResultSet rs = null;
		String query = "SELECT Name,Passhash FROM User;";

		try {
			connection = createConnection();
			Statement statement = connection.createStatement();
			rs = statement.executeQuery(query);
			try {
				while (rs.next()) {
					User usr = new User();
					usr.setName(rs.getString("Name"));
					usr.setPasshash(rs.getString("Passhash"));
					userReturn.add(usr);
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}

		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
		} finally {
			closeConnection(connection);
		}
		User[] result = new User[userReturn.size()];
		return  userReturn.toArray(result);
	}
	
 	public User[] getUsersThatAccessNote(int id) {
		// gets all users that have access to a note and the notes owner and returns
		// them in a array where [0] is the owner and the rest go after
		List<User> users = new ArrayList<User>();

		Connection connection = null;
		ResultSet rs = null;
		String query = "SELECT User,ID FROM Users_Access_Notes WHERE ID = '" + id + "';";

		try {
			connection = createConnection();
			Statement statement = connection.createStatement();
			rs = statement.executeQuery(query);
			try {
				users.add(getUser(getNote(id).getOwner()));
				while (rs.next()) {
					users.add(getUser(rs.getString("User")));
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}

		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
		} finally {
			closeConnection(connection);
		}

		return users.toArray(new User[users.size()]);
	}

	public Note[] getNotesThatUserAccess(String name) {
		// gets all users that have access to a note and the notes owner and returns
		// them in a array where [0] is the owner and the rest go after
		List<Note> notes = new ArrayList<Note>();

		Connection connection = null;
		ResultSet rs = null;
		String query = "SELECT User,ID FROM Users_Access_Notes WHERE User = '" + name + "';";

		try {
			connection = createConnection();
			Statement statement = connection.createStatement();
			rs = statement.executeQuery(query);
			try {
				while (rs.next()) {
					notes.add(getNote(rs.getInt("ID")));
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}

		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
		} finally {
			closeConnection(connection);
		}

		return notes.toArray(new Note[notes.size()]);
	}

	public boolean modifyNote(int id, String title, String content) {
		return runQuery("UPDATE User SET Title = " + title + " ,Content = " + content + " WHERE ID =" + id + ";");
	}

	public void createDB() {
		Connection connection = null;
		try {
			connection = createConnection();
			Statement statement = connection.createStatement();
			statement.executeUpdate("CREATE TABLE User (\r\n" + "    Name     VARCHAR PRIMARY KEY\r\n"
					+ "                     UNIQUE\r\n" + "                     NOT NULL,\r\n"
					+ "    Passhash TEXT    NOT NULL\r\n" + ");\r\n" + ""); // Create
																			// table
																			// User

			statement.executeUpdate("CREATE TABLE Note (\r\n" + "    ID      INTEGER PRIMARY KEY AUTOINCREMENT,\r\n"
					+ "    Owner   VARCHAR REFERENCES User (Name) ON DELETE CASCADE\r\n"
					+ "                                           ON UPDATE CASCADE,\r\n"
					+ "    Title   TEXT    NOT NULL,\r\n" + "    Content TEXT    NOT NULL\r\n" + ");\r\n" + ""); // Create
																													// table
																													// Note

			statement.executeUpdate("CREATE TABLE Users_Access_Notes (\r\n"
					+ "    User VARCHAR REFERENCES User (Name) ON DELETE CASCADE\r\n"
					+ "                                        ON UPDATE CASCADE,\r\n"
					+ "    ID   INTEGER REFERENCES Note (ID) ON DELETE CASCADE\r\n"
					+ "                                      ON UPDATE CASCADE\r\n" + ");\r\n" + ""); // Create table
			// Users_Access_Notes
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	public void deleteDB() {
		Connection connection = null;
		try {
			connection = createConnection();
			Statement statement = connection.createStatement();
			statement.executeUpdate("DROP TABLE User;");
			statement.executeUpdate("DROP TABLE Notes;");
			statement.executeUpdate("DROP TABLE Users_Access_Notes;");


		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	public boolean checkDB() {
		Connection connection = null;
		try {
			connection = createConnection();
		} catch (ClassNotFoundException e1) {
			e1.printStackTrace();
		}

		Statement statement = null;
		try {
			statement = connection.createStatement();
		} catch (SQLException e1) {
			e1.printStackTrace();
		}
		try {
			statement.executeQuery("select * from User"); // this is a temporary check, it only checks
															// the validity of the USER table and
															// assumes the rest is valid
			return true;
		} catch (SQLException e) {
			return false;
		}
	}
}