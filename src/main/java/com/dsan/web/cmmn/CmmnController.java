package com.dsan.web.cmmn;

import java.io.IOException;
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

import com.dsan.web.cmmn.service.CmmnService;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

@Controller
public class CmmnController {
	private static final Logger LOGGER = LoggerFactory.getLogger(CmmnController.class);

	@Autowired
	private CmmnService service;

	// common
	@RequestMapping(value = "/getProcInfoList", produces = "application/json; charset=utf8")
	@ResponseBody
	public List<HashMap<String, Object>> getProcInfoList(@RequestBody String param)
			throws JsonParseException, JsonMappingException, IOException {
		HashMap<String, Object> map = new ObjectMapper().readValue(param, new TypeReference<Map<String, Object>>() {
		});
		return service.getProcInfoList(map);
	}

	@RequestMapping(value = "/getHstnTagList", produces = "application/json; charset=utf8")
	@ResponseBody
	public List<HashMap<String, Object>> getHstnTagList(@RequestBody String param)
			throws JsonParseException, JsonMappingException, IOException {
		HashMap<String, Object> map = new ObjectMapper().readValue(param, new TypeReference<Map<String, Object>>() {
		});
		return service.getHstnTagList(map);
	}

	@RequestMapping(value = "/getHstnTagList2", produces = "application/json; charset=utf8")
	@ResponseBody
	public List<HashMap<String, Object>> getHstnTagList2(@RequestBody String param)
			throws JsonParseException, JsonMappingException, IOException {
		HashMap<String, Object> map = new ObjectMapper().readValue(param, new TypeReference<Map<String, Object>>() {
		});
		// List<HashMap<String, Object>> procsList = (List<HashMap<String,
		// Object>>)map.get("procs_list");
		// List<HashMap<String, Object>> fcltList = (List<HashMap<String,
		// Object>>)map.get("fclt_list");
		return service.getHstnTagList2(map);
	}

	@RequestMapping(value = "/getEvntInfoList", produces = "application/json; charset=utf8")
	@ResponseBody
	public List<HashMap<String, Object>> getEvntInfoList(@RequestBody String param)
			throws JsonParseException, JsonMappingException, IOException {
		HashMap<String, Object> map = new ObjectMapper().readValue(param, new TypeReference<Map<String, Object>>() {
		});
		return service.getEvntInfoList(map);
	}

	@RequestMapping(value = "/getFcltInfoList", produces = "application/json; charset=utf8")
	@ResponseBody
	public List<HashMap<String, Object>> getFcltInfoList(@RequestBody String param)
			throws JsonParseException, JsonMappingException, IOException {
		HashMap<String, Object> map = new ObjectMapper().readValue(param, new TypeReference<Map<String, Object>>() {
		});
		return service.getFcltInfoList(map);
	}

	@RequestMapping(value = "/getFcltDeatilInfoList", produces = "application/json; charset=utf8")
	@ResponseBody
	public List<HashMap<String, Object>> getFcltDeatilInfoList(@RequestBody String param)
			throws JsonParseException, JsonMappingException, IOException {
		HashMap<String, Object> map = new ObjectMapper().readValue(param, new TypeReference<Map<String, Object>>() {
		});
		return service.getFcltDeatilInfoList(map);
	}

	@RequestMapping(value = "/getDataSourceInfoList", produces = "application/json; charset=utf8")
	@ResponseBody
	public List<HashMap<String, Object>> getDataSourceInfoList(@RequestBody String param)
			throws JsonParseException, JsonMappingException, IOException {
		HashMap<String, Object> map = new ObjectMapper().readValue(param, new TypeReference<Map<String, Object>>() {
		});
		return service.getDataSourceInfoList(map);
	}
}