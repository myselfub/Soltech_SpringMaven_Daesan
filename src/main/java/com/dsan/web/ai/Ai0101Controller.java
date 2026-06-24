package com.dsan.web.ai;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.dsan.web.ai.service.Ai0101Service;
import com.dsan.web.ai.vo.EvntVO;
import com.dsan.web.ai.vo.ImgFileVO;
import com.dsan.web.util.Ai0101ReportUtils;

@Controller
public class Ai0101Controller {
	@Autowired
	private ServletContext servletContext;

	@Autowired
	private Ai0101Service service;

	@RequestMapping(value = "/getEvntList")
	@ResponseBody
	public List<EvntVO> getEvntList(EvntVO vo) throws Exception {
		return service.getEvntList(vo);
	}

	@RequestMapping(value = "/getAtchFileList")
	@ResponseBody
	public List<ImgFileVO> getAtchFileList(com.dsan.web.ai.vo.ImgFileVO vo) throws Exception {
		return service.getAtchFileList(vo);
	}

	@RequestMapping(value = "/onSaveEvntInfo")
	public @ResponseBody String onSaveEvntInfo(final MultipartHttpServletRequest multiRequest,
			@ModelAttribute("EvntVO") EvntVO evtVo, @ModelAttribute("ImgFileVO") ImgFileVO fileVo) throws Exception {

		int next_seq = service.getNextEvntId();
		String evnt_id = "EVNT_" + next_seq;
		String atch_file_id = null;

		int fileCnt = Integer.parseInt(multiRequest.getParameter("fileCnt"));
		if (fileCnt > 0) {
			atch_file_id = "EVNTFILE_" + next_seq;
			for (int i = 1; i <= fileCnt; i++) {
				MultipartFile file = multiRequest.getFile("file" + i);
				byte[] byte_img = file.getBytes();
				if (byte_img.length > 0) {
					fileVo.setAtch_file_id(atch_file_id);
					fileVo.setFile_sn(i);
					fileVo.setStrg_type_cd("1");
					fileVo.setByte_img(byte_img);
					fileVo.setOrgnl_file_nm(file.getOriginalFilename());
					fileVo.setFile_type(file.getContentType());
					service.onSaveEvntAtchFile(fileVo);
				}
			}
		}

		evtVo.setEvnt_id(evnt_id);
		evtVo.setAtch_file_id(atch_file_id);

		service.onSaveEvntInfo(evtVo);
		return evnt_id;

	}

	@RequestMapping(value = "/onUpdateEvntInfo")
	public @ResponseBody HashMap<String, Object> onUpdateEvntInfo(final MultipartHttpServletRequest multiRequest,
			@ModelAttribute("EvntVO") EvntVO evtVo, @ModelAttribute("ImgFileVO") ImgFileVO fileVo) throws Exception {

		HashMap<String, Object> result = new HashMap<String, Object>();

		String evnt_id = multiRequest.getParameter("evnt_id");
		if (evnt_id.equals("")) {
			result.put("result", "evnt id is null");
		} else {

			String atch_file_id = multiRequest.getParameter("atch_file_id");

			int fileCnt = Integer.parseInt(multiRequest.getParameter("fileCnt"));
			if (fileCnt > 0) {

				if (atch_file_id == null || atch_file_id.isEmpty() || atch_file_id.equals("")) {
					int next_seq = service.getNextEvntId();
					atch_file_id = "EVNTFILE_" + next_seq;
				}

				for (int i = 1; i <= fileCnt; i++) {
					MultipartFile file = multiRequest.getFile("file" + i);
					byte[] byte_img = file.getBytes();
					if (byte_img.length > 0) {
						fileVo.setAtch_file_id(atch_file_id);
						fileVo.setFile_sn(i);
						fileVo.setStrg_type_cd("1");
						fileVo.setByte_img(byte_img);
						fileVo.setOrgnl_file_nm(file.getOriginalFilename());
						fileVo.setFile_type(file.getContentType());
						service.onSaveEvntAtchFile(fileVo);
					}
				}
			}

			evtVo.setEvnt_id(evnt_id);
			evtVo.setAtch_file_id(atch_file_id);

			service.onSaveEvntInfo(evtVo);

			result.put("result", "success");
			result.put("evnt_id", evnt_id);
		}

		return result;

	}

	// 이벤트 삭제
	@RequestMapping(value = "/onDeleteEvntInfo")
	public @ResponseBody HashMap<String, Object> onDeleteEvntInfo(final MultipartHttpServletRequest multiRequest,
			@ModelAttribute("EvntVO") EvntVO evtVo) throws Exception {
		HashMap<String, Object> result = new HashMap<String, Object>();

		String evnt_id = multiRequest.getParameter("evnt_id");
		// 유효성 검사
		if (evnt_id == null || evnt_id.isEmpty()) {
			result.put("result", "evnt id is null");
		} else {
			evtVo.setEvnt_id(evnt_id);
			// 삭제 서비스 호출
			service.onDeleteEvntInfo(evtVo);

			String atch_file_id = multiRequest.getParameter("atch_file_id");

			if (atch_file_id != null && !atch_file_id.equals("")) {
				evtVo.setAtch_file_id(atch_file_id);
				service.onDeleteEvntAtchFile(evtVo);
			}

			result.put("result", "success");
		}

		return result;
	}

	@RequestMapping(value = "/ai0101/excel")
	public @ResponseBody String excelDownload(HttpServletResponse response, @ModelAttribute("EvntVO") EvntVO evtVo)
			throws Exception {
		if (ObjectUtils.isEmpty(evtVo.getBgng_dt())) {
			throw new Exception("bgng_dt Is Null");
		}
		Ai0101ReportUtils ai0101ReportUtils = new Ai0101ReportUtils(servletContext);
		try {
			ai0101ReportUtils.setExcelDatas(response, evtVo.getBgng_dt() + "_인수인계일지", evtVo.getBgng_dt(),
					service.getReport(evtVo));
		} catch (IOException e) {
			e.printStackTrace();
		}

		return "Success";
	}
}