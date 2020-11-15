package notes.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

import notes.controller.*;
import notes.model.User;

@WebServlet("/NotesServlet")
public class NotesServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public NotesServlet() {
		super();
	}

	protected void processRequest(HttpServletRequest request, HttpServletResponse response) {
		NotesController controller = new NotesController();
		Map<String, Object> map = new HashMap<String, Object>();

		switch (request.getParameter("formType")) {
		case "register":
			map.put("name", request.getParameter("name"));
			if (request.getParameter("password").equals(request.getParameter("passwordCheck"))) {
				String[] inp = new String[] { request.getParameter("name"), request.getParameter("password") };
				if (controller.register(inp)) {
					map.put("isOkay", true);
				} else {
					map.put("isOkay", false);
				}
			}
			break;
		case "login":
			map.put("name", request.getParameter("name"));
			String[] inp = new String[] { request.getParameter("name"), request.getParameter("password") };
			if (controller.login(inp)) {
				map.put("isOkay", true);
			} else {
				map.put("isOkay", false);
			}
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
		}

		try {
			write(response, map);
		} catch (IOException e) {
			e.printStackTrace();
		}

		request.getParameter("formType");
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
