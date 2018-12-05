package myshop.controller;

import java.sql.SQLIntegrityConstraintViolationException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

import common.controller.AbstractController;
import member.model.MemberVO;
import myshop.model.InterProductDAO;
import myshop.model.ProductDAO;

public class LikeAddAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

		String pnum = req.getParameter("pnum");
		String userid = req.getParameter("userid");
		
		JSONObject jsonObj = new JSONObject();
//		로그인 유무 검사		
		if("".equals(userid) || userid == null) {	// null이 아니라 ""값으로 들어올 수 있기 때문에 null비교 X
			jsonObj.put("msg", "로그인이 필요한 서비스입니다. \n 로그인 후 다시 시도하세요.");
		}
		else {
			InterProductDAO pdao = new ProductDAO();
			
			
			try {
				int n = pdao.insertLike(userid, pnum);
				if(n==1) {
					jsonObj.put("msg", "좋아요 완료!");
				}
			} catch (SQLIntegrityConstraintViolationException e) {
				jsonObj.put("msg", "이미 좋아요를 하셨습니다.");
			}
			
		}
		
		String str_jsonObj = jsonObj.toString();
		
		req.setAttribute("str_jsonObj", str_jsonObj);
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/myshop/likeAdd.jsp");
	}

}
