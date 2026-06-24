package com.dsan.web.ai;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.dsan.web.ai.service.Ai0102Service;
import com.dsan.web.ai.vo.EvntVO;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

@Controller
public class Ai0102Controller {

	@Autowired
	private Ai0102Service service;

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/getFcltDList", produces = "application/json; charset=utf8")
	@ResponseBody
	public List<HashMap<String, Object>> getFcltDList(@RequestBody String param) throws Exception {
		HashMap<String, Object> map = new ObjectMapper().readValue(param, new TypeReference<Map<String, Object>>() {
		});

		List<HashMap<String, Object>> fcltList = (List<HashMap<String, Object>>) map.get("fcltList");

		return service.getFcltDList(fcltList);

	}

	@RequestMapping(value = "/getEvntList2", produces = "application/json; charset=utf8")
	@ResponseBody
	public List<EvntVO> getEvntList2(@RequestBody String param) throws Exception {
		HashMap<String, Object> map = new ObjectMapper().readValue(param, new TypeReference<Map<String, Object>>() {
		});
		return service.getEvntList2(map);
	}
}