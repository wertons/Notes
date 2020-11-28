package notes.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

import notes.controller.*;
import notes.model.*;

@WebServlet("/NotesServlet")
public class NotesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public NotesServlet() {
        super();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response) {
        NotesController controller = new NotesController();
        Map<String, Object> map = new HashMap<String, Object>();
        String name = readCookie("username", request);
        String pass = readCookie("password", request);

        switch (request.getParameter("formType")) {
            case "register":
                map.put("name", request.getParameter("name"));
                if (request.getParameter("password").equals(request.getParameter("passwordCheck"))) {
                    String[] inp = new String[]{request.getParameter("name"), request.getParameter("password")};
                    if (controller.register(inp)) {
                        map.put("isOkay", true);
                    } else {
                        map.put("isOkay", false);
                    }
                }
                break;
            case "login":
                String uName = request.getParameter("name");
                map.put("name", uName);
                String[] inp = new String[]{uName, request.getParameter("password")};
                if (controller.login(inp)) {
                    // store cookies only when login is valid
                    Cookie nameCookie = new Cookie("username", uName);
                    nameCookie.setMaxAge(60 * 60 * 24);
                    response.addCookie(nameCookie);

                    Cookie passCookie = new Cookie("password", request.getParameter("password"));
                    passCookie.setMaxAge(60 * 60 * 24);
                    response.addCookie(passCookie);
                    map.put("isOkay", true);

                } else {
                    map.put("isOkay", false);
                }

                break;
            case "logout":
                Cookie nameCookie = new Cookie("username", "");
                Cookie passCookie = new Cookie("password", "");

                nameCookie.setMaxAge(0);
                passCookie.setMaxAge(0);

                response.addCookie(nameCookie);
                response.addCookie(passCookie);

                map.put("isOkay", true);

                break;
            case "createDB":
                try {
                    controller.createDB();

                    map.put("isOkay", true);
                } catch (Exception e) {
                    map.put("isOkay", false);
                }

                break;
            case "deleteDB":
                try {
                    controller.deleteDB();

                    map.put("isOkay", true);
                } catch (Exception e) {
                    map.put("isOkay", false);
                }

                break;
            case "createNote":
                try {
                    Note note = new Note();
                    note.setOwner(readCookie("username", request));
                    note.setTitle(request.getParameter("title"));
                    note.setBody(request.getParameter("content"));

                    controller.createNote(note);

                    map.put("isOkay", true);

                } catch (Exception e) {
                    map.put("isOkay", false);

                }

                break;
            case "deleteNote":
                try {
                    controller.deleteNote(request.getParameter("id"));
                    map.put("isOkay", true);
                } catch (Exception e) {
                    map.put("isOkay", false);

                }
                break;
            case "getOwnerNotes":
                try {
                    map.put("notes", controller.getUserNotes(name));
                    map.put("isOkay", true);
                } catch (Exception e) {
                    map.put("isOkay", false);
                }
                break;
            case "getAcNotes":
                try {
                    map.put("notes", controller.getNotesThatUserAccess(name));
                    map.put("isOkay", true);
                } catch (Exception e) {
                    map.put("isOkay", false);
                }
                break;
            case "grantAc":
                try {
                    controller.createAccessToNote(name, request.getParameter("user"), request.getParameter("id"));
                    map.put("isOkay", true);
                } catch (Exception e) {
                    map.put("isOkay", false);
                }
                break;
            case "getUserAc":
                try {
                    User[] users = controller.getUsersThatAccessNote(request.getParameter("id"));
                    String[] userArr = new String[users.length];
                    for (int i = 0; i < users.length; i++) {
                        userArr[i] = users[i].getName();
                    }
                    map.put("users", userArr);
                    map.put("isOkay", true);
                } catch (Exception e) {
                    map.put("isOkay", false);
                }
                break;
            case "deleteAc":
                try {
                    String user = "";
                    if (request.getParameter("user").equals("")) {
                        user = name;
                    } else {
                        user = request.getParameter("user");
                    }
                    controller.deleteAccessToNote(name, user, request.getParameter("id"));
                    map.put("isOkay", true);
                } catch (Exception e) {
                    map.put("isOkay", false);
                }
                break;
            case "startUp":

                System.out.println("cookie name:" + name + " cookie pass:" + pass);
                System.out.println("trying to log in");
                if (name == null || pass == null) {
                    map.put("isOkay", false);
                    System.out.println("couldn't log in");
                } else {
                    if (controller.login(new String[]{name, pass})) {
                        map.put("name", name);

                        map.put("isOkay", true);
                        System.out.println("logged in");

                    } else {
                        map.put("isOkay", false);
                        System.out.println("couldn't log in");

                    }
                }

                break;
            case "updateNoteForm":
                Note noteUpdate = new Note();

                noteUpdate.setId(Integer.parseInt(request.getParameter("id")));
                noteUpdate.setOwner(name);
                noteUpdate.setTitle(request.getParameter("title"));
                noteUpdate.setBody((request.getParameter("content")));

                try {
                    controller.updateNote(noteUpdate);

                    map.put("isOkay", true);

                } catch (Exception e) {
                    map.put("isOkay", false);

                }

                break;
        }

        try {
            write(response, map);
        } catch (IOException e) {
            e.printStackTrace();
        }

        request.getParameter("formType");
    }

    public String readCookie(String key, HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        for (int i = 0; i < cookies.length; i++) {

            Cookie cookie = cookies[i];

            if (key.equals(cookie.getName())) {

                return (cookie.getValue());
            }

        }
        return null;
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);

    }

    private void write(HttpServletResponse response, Map<String, Object> map) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(new Gson().toJson(map));
    }

}
