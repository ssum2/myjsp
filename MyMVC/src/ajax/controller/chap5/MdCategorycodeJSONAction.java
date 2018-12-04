package ajax.controller.chap5;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import ajax.model.AjaxDAO;
import ajax.model.InterAjaxDAO;
import common.controller.AbstractController;

public class MdCategorycodeJSONAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
		
		String lgcategorycode = req.getParameter("lgcategorycode");
		
		InterAjaxDAO adao = new AjaxDAO();
		
		List<HashMap<String, String>> mdcategorycodeList = adao.getMdcategorycode(lgcategorycode);
		
		JSONArray jsonArray = new JSONArray();
		
		if(mdcategorycodeList != null && mdcategorycodeList.size() > 0) {
			for(HashMap<String, String> map : mdcategorycodeList) {
				JSONObject jsonObj = new JSONObject();
				// JSONObject 는 JSON형태(키:값)의 데이터를 관리해 주는 클래스이다.
				
			    jsonObj.put("MDCATEGORYCODE", map.get("MDCATEGORYCODE"));
			    jsonObj.put("CODENAME", map.get("CODENAME"));
			    			    	    
			    jsonArray.add(jsonObj);
			}
		}
		
		String str_jsonArray = jsonArray.toString();
		
		req.setAttribute("str_jsonArray", str_jsonArray);
				
		super.setRedirect(false);
		super.setViewPage("/ajaxstudy/chap5/mdcategorycodeJSON.jsp");

	}// end of void execute(HttpServletRequest req, HttpServletResponse res)----------------

}
