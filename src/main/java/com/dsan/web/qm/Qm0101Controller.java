package com.dsan.web.qm;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.dsan.web.qm.service.Qm0101Service;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

@Controller
public class Qm0101Controller {
	private static final Logger LOGGER = LoggerFactory.getLogger(Qm0101Controller.class);

	@Autowired
	private Qm0101Service service;

	@RequestMapping(value = "/getDataQcHstyList", produces = "application/json; charset=utf8")
	@ResponseBody
	public List<HashMap<String, Object>> getDataQcHstyList(@RequestBody String param) throws Exception {
		HashMap<String, Object> map = new ObjectMapper().readValue(param, new TypeReference<Map<String, Object>>() {
		});
		return service.getDataQcHstyList(map);
	}

	@RequestMapping(value = "/insertDataQcHsty", produces = "application/json; charset=utf8")
	@ResponseBody
	public int insertDataQcHsty(@RequestBody String param) throws Exception {
		HashMap<String, Object> map = new ObjectMapper().readValue(param, new TypeReference<Map<String, Object>>() {
		});
		ArrayList<HashMap<String, Object>> list = (ArrayList<HashMap<String, Object>>) map.get("list");
		return service.insertDataQcHsty(list);
	}
}