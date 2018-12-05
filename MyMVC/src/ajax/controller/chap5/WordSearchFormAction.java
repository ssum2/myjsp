package ajax.controller.chap5;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import ajax.model.AjaxDAO;
import ajax.model.InterAjaxDAO;
import common.controller.AbstractController;

public class WordSearchFormAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res)
		throws Exception {
		
		String lgcategorycode = req.getParameter("lgcategorycode");
		InterAjaxDAO adao = new AjaxDAO();
		
		if(lgcategorycode == null)
			lgcategorycode = adao.getMinLgcategorycode();
		
		List<HashMap<String, String>> lgcategorycodeList = adao.getLgcategorycode();
		List<HashMap<String, String>> mdcategorycodeList = adao.getMdcategorycode(lgcategorycode);
		
		req.setAttribute("lgcategorycodeList", lgcategorycodeList); 
		req.setAttribute("mdcategorycodeList", mdcategorycodeList);
		
		super.setViewPage("/ajaxstudy/chap5/wordSearchFormAjax.jsp");

	}	
	
}
