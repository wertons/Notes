package notes.controller;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import notes.dao.*;
import notes.model.*;

public class NotesController {
	NotesDAO dao;

	public NotesController(){
		dao = new NotesDAO();
	}

	public boolean login(String[] log) {
		User inUsr = new User(log[0], hashString(log[1]));

		return inUsr.compare(dao.getUser(inUsr.getName()));
	}

	public boolean register(String[] reg) {
		User inUsr = new User(reg[0], hashString(reg[1]));
		return dao.insertUser(inUsr);
	}

	public String[] userList() {
		User[] dbList = dao.getAllUsers();
		List<String> list = new ArrayList<String>();
		for (int i = 0; i < dbList.length; i++) {
			list.add("User number " + (i + 1) + " : " + dbList[i].getName() + " | " + dbList[i].getPasshash());
		}
		String[] result = new String[list.size()];

		result = list.toArray(result);

		return result;
	}
	
	public Note[] getUserNotes(String owner) {

		return dao.getNotesByOwner(owner);
		
	}

	
	public void createDB() {
		if (!dao.checkDB()) {
			dao.createDB();
			loadPrebuiltDB();
		}

	}

	public void deleteDB() {
		dao.deleteDB();
	}

	public void createNote(Note note) {
		if (note.getTitle().length() >= 40) {
			System.out.println("too long of a title");
		} else {
			dao.insertNote(note);
		}
	}

	public void loadPrebuiltDB() {

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

		usr = new User("Jesucristo", hashString("Superstar"));
		dao.insertUser(usr);

		usr = new User("SCP", hashString("096"));
		dao.insertUser(usr);

		usr = new User("La botella", hashString("de agua"));
		dao.insertUser(usr);

		// preset notes
		Note note = new Note();

		note = new Note("root", "TestNote1", "<p>note1content</p>");
		dao.insertNote(note);

		note = new Note("root", "TestNote2", "<h1>note1content</h1>");
		dao.insertNote(note);

		note = new Note("root", "TestNote3", "<h3>note1content</h3>");
		dao.insertNote(note);

		note = new Note("admin", "I am a god", "Fear me");
		dao.insertNote(note);

		note = new Note("user", "A note for everyone", "But no for you");
		dao.insertNote(note);

		note = new Note("Pere", "for root", "pere");
		dao.insertNote(note);

		note = new Note("Juan", "for root", "juan");
		dao.insertNote(note);

		note = new Note("Manu", "for root", "manu");
		dao.insertNote(note);

		note = new Note("SCP", "for Pere", " only Pere");
		dao.insertNote(note);

		note = new Note("SCP", "for Juan", "only Juan");
		dao.insertNote(note);

		note = new Note("SCP", "for Manu", "only Manu");
		dao.insertNote(note);

		note = new Note("SCP", "for root", "");
		dao.insertNote(note);

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
