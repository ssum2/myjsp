package myshop.controller;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

import common.controller.AbstractController;
import myshop.model.InterProductDAO;
import myshop.model.ProductDAO;

public class LikeDislikeCntShowAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
//		pnum 받아오기
		String pnum = req.getParameter("pnum");
//		DAO에서 좋아요, 싫어요 수 select
		InterProductDAO pdao = new ProductDAO();
		HashMap<String, Integer> likeDislikeMap = pdao.getLikeDislikeCnt(pnum);
		
//		JSON객체에 map의 select한 결과물을 put
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("likeCnt", likeDislikeMap.get("likeCnt"));
		jsonObj.put("dislikeCnt", likeDislikeMap.get("dislikeCnt"));
		
		
		String str_jsonObj = jsonObj.toString();
		req.setAttribute("str_jsonObj", str_jsonObj);
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/myshop/likeDislikeCntShowJSON.jsp");
	}

}
