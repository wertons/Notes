package notes.controller;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import notes.dao.*;
import notes.model.*;

public class NotesController {

	public boolean login(String[] log) {
		User inUsr = new User(log[0], hashString(log[1]));


		return inUsr.compare(new NotesDAO().getUser(inUsr.getName()));
	}

	public boolean register(String[] reg) {
		User inUsr = new User(reg[0], hashString(reg[1]));
		NotesDAO dao = new NotesDAO();

		return dao.insertUser(inUsr);
	}

	public String[] userList() {
		NotesDAO dao = new NotesDAO();
		User[] dbList = dao.getAllUsers();
		List<String> list = new ArrayList<String>();
		for (int i = 0; i < dbList.length; i++) {
			list.add("User number " + (i + 1) + " : " + dbList[i].getName() + " | " + dbList[i].getPasshash());
		}
		String[] result = new String[list.size()];

		result = list.toArray(result);

		return result;
	}

	public void createDB() {
		NotesDAO dao = new NotesDAO();
		dao.createDB();
		loadPrebuiltDB();

	}

	public void deleteDB() {
		NotesDAO dao = new NotesDAO();
		dao.deleteDB();
	}

	public void loadPrebuiltDB() {

		NotesDAO dao = new NotesDAO();
		// preset users
		User usr = new User();
		usr = new User("root", hashString("root"));
		dao.insertUser(usr);
		
		usr = new User("admin", hashString("1234"));
		dao.insertUser(usr);
		
		usr = new User("Pepe", hashString("moroso"));
		dao.insertUser(usr);
		
		usr = new User("user", hashString("password"));
		dao.insertUser(usr);
		
		usr = new User("Juan", hashString("1234"));
		dao.insertUser(usr);
		
		usr = new User("Pere", hashString("1234"));
		dao.insertUser(usr);
		
		usr = new User("Manu", hashString("1234"));
		dao.insertUser(usr);
		
		usr =new User("Jesucristo", hashString("Superstart"));
		dao.insertUser(usr);
		
		usr =new User("SCP", hashString("096"));
		dao.insertUser(usr);
		
		usr =new User("La botella", hashString("de agua"));
		dao.insertUser(usr);

		// preset notes
		dao.insertNote("root", "TestNote1", "<p>note1content</p>");
		dao.insertNote("root", "TestNote2", "<h1>note1content</h1>");
		dao.insertNote("root", "TestNote3", "<h3>note1content</h3>");
		dao.insertNote("admin", "I am a god", "Fear me");
		dao.insertNote("user", "A note for everyone", "But no for you");
		dao.insertNote("Pere", "for root", "pere");
		dao.insertNote("Juan", "for root", "juan");
		dao.insertNote("Manu", "for root", "manu");
		dao.insertNote("SCP", "for Pere", " only Pere");
		dao.insertNote("SCP", "for Juan", "only Juan");
		dao.insertNote("SCP", "for Manu", "only Manu");
		dao.insertNote("SCP", "for root", "");

		// preset access
		dao.insertUsers_Access_Notes("admin", 5);
		dao.insertUsers_Access_Notes("Pep", 5);
		dao.insertUsers_Access_Notes("user", 5);
		dao.insertUsers_Access_Notes("Jesucristo", 5);
		dao.insertUsers_Access_Notes("La botella", 5);
		dao.insertUsers_Access_Notes("root", 6);
		dao.insertUsers_Access_Notes("root", 7);
		dao.insertUsers_Access_Notes("root", 8);
		dao.insertUsers_Access_Notes("Pere", 9);
		dao.insertUsers_Access_Notes("Juan", 10);
		dao.insertUsers_Access_Notes("Manu", 11);
		dao.insertUsers_Access_Notes("root", 12);

	}

	String hashString(String str) {
		MessageDigest messageDigest = null;
		try {
			messageDigest = MessageDigest.getInstance("SHA-256");
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}
		messageDigest.update(str.getBytes());
		return new String(messageDigest.digest());

	}
}
