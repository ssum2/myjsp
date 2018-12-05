package test.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;

public class Test4Controller extends AbstractController {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
		req.setAttribute("result", "Test2Controller에서 넘겨준 값은 <span style='color: red;'>\"E클래스의 훈남\"</span>입니다.");
		req.setAttribute("name", "홍석화");
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/test/test4.jsp");
	}

}
