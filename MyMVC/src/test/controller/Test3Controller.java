package test.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;

public class Test3Controller extends AbstractController {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
		req.setAttribute("result", "Test2Controller에서 넘겨준 값은 <span style='color: red;'>\"E클래스의 인기남\"</span>입니다.");
		req.setAttribute("name", "이현재");
		
		super.setRedirect(false);
		super.setViewPage("/test/test3.jsp");
	}

}
