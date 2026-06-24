package com.dsan.web.em;

import com.dsan.web.em.service.Em0105Service;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
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

@Controller
public class Em0105Controller {
	private static final Logger LOGGER = LoggerFactory.getLogger(Em0105Controller.class);
	@Autowired
	private Em0105Service service;

	@RequestMapping(value = { "/getGridStatisticsData" }, produces = { "application/json; charset=utf8" })
	@ResponseBody
	public List<HashMap<String, Object>> getGridStatisticsData(@RequestBody String param)
			throws JsonParseException, JsonMappingException, IOException {
		HashMap map = (HashMap) new ObjectMapper().readValue(param,
				(TypeReference) new TypeReference<Map<String, Object>>() {
				});
		return this.service.getGridStatisticsData(map);
	}

	@RequestMapping(value = { "/getGridPwereUsgPrc" }, produces = { "application/json; charset=utf8" })
	@ResponseBody
	public List<HashMap<String, Object>> getGridPwereUsgPrc(@RequestBody String param)
			throws JsonParseException, JsonMappingException, IOException {
		HashMap map = (HashMap) new ObjectMapper().readValue(param,
				(TypeReference) new TypeReference<Map<String, Object>>() {
				});
		return this.service.getGridPwereUsgPrc(map);
	}

	// 실시간 전력 조회
	@RequestMapping(value = { "/getRealTimePower" }, produces = { "application/json; charset=utf8" })
	@ResponseBody
	public List<HashMap<String, Object>> getRealTimePower(@RequestBody String param)
			throws JsonParseException, JsonMappingException, IOException {
		HashMap map = (HashMap) new ObjectMapper().readValue(param,
				(TypeReference) new TypeReference<Map<String, Object>>() {
				});
		return this.service.getRealTimePower(map);
	}

	// 금일 전력량 조회
	@RequestMapping(value = { "/getTodayPowerUsage" }, produces = { "application/json; charset=utf8" })
	@ResponseBody
	public List<HashMap<String, Object>> getTodayPowerUsage(@RequestBody String param)
			throws JsonParseException, JsonMappingException, IOException {
		HashMap map = (HashMap) new ObjectMapper().readValue(param,
				(TypeReference) new TypeReference<Map<String, Object>>() {
				});
		return this.service.getTodayPowerUsage(map);
	}

	// 금일 최대 전력 조회
	@RequestMapping(value = { "/getTodayMaxPower" }, produces = { "application/json; charset=utf8" })
	@ResponseBody
	public List<HashMap<String, Object>> getTodayMaxPower(@RequestBody String param)
			throws JsonParseException, JsonMappingException, IOException {
		HashMap map = (HashMap) new ObjectMapper().readValue(param,
				(TypeReference) new TypeReference<Map<String, Object>>() {
				});
		return this.service.getTodayMaxPower(map);
	}

	// 금일 소비 요금 조회
	@RequestMapping(value = { "/getTodayPowerCost" }, produces = { "application/json; charset=utf8" })
	@ResponseBody
	public List<HashMap<String, Object>> getTodayPowerCost(@RequestBody String param)
			throws JsonParseException, JsonMappingException, IOException {
		HashMap map = (HashMap) new ObjectMapper().readValue(param,
				(TypeReference) new TypeReference<Map<String, Object>>() {
				});
		return this.service.getTodayPowerCost(map);
	}

	// 차트용 시간별 누적 전력량 조회
	@RequestMapping(value = { "/getChartHourlyPowerUsage" }, produces = { "application/json; charset=utf8" })
	@ResponseBody
	public List<HashMap<String, Object>> getChartHourlyPowerUsage(@RequestBody String param)
			throws JsonParseException, JsonMappingException, IOException {
		HashMap map = (HashMap) new ObjectMapper().readValue(param,
				(TypeReference) new TypeReference<Map<String, Object>>() {
				});
		return this.service.getChartHourlyPowerUsage(map);
	}

	// 차트용 시간별 소비 요금 조회
	@RequestMapping(value = { "/getChartHourlyCost" }, produces = { "application/json; charset=utf8" })
	@ResponseBody
	public List<HashMap<String, Object>> getChartHourlyCost(@RequestBody String param)
			throws JsonParseException, JsonMappingException, IOException {
		HashMap map = (HashMap) new ObjectMapper().readValue(param,
				(TypeReference) new TypeReference<Map<String, Object>>() {
				});
		return this.service.getChartHourlyCost(map);
	}

	// 시설별 실시간 전력 조회
	@RequestMapping(value = { "/getFacilityRealTimePower" }, produces = { "application/json; charset=utf8" })
	@ResponseBody
	public List<HashMap<String, Object>> getFacilityRealTimePower(@RequestBody String param)
			throws JsonParseException, JsonMappingException, IOException {
		HashMap map = (HashMap) new ObjectMapper().readValue(param,
				(TypeReference) new TypeReference<Map<String, Object>>() {
				});
		return this.service.getFacilityRealTimePower(map);
	}

	// 시설별 금일 최대 전력 조회
	@RequestMapping(value = { "/getFacilityMaxPower" }, produces = { "application/json; charset=utf8" })
	@ResponseBody
	public List<HashMap<String, Object>> getFacilityMaxPower(@RequestBody String param)
			throws JsonParseException, JsonMappingException, IOException {
		HashMap map = (HashMap) new ObjectMapper().readValue(param,
				(TypeReference) new TypeReference<Map<String, Object>>() {
				});
		return this.service.getFacilityMaxPower(map);
	}

	// 시설별 소비 전력량 조회
	@RequestMapping(value = { "/getFacilityPowerUsage" }, produces = { "application/json; charset=utf8" })
	@ResponseBody
	public List<HashMap<String, Object>> getFacilityPowerUsage(@RequestBody String param)
			throws JsonParseException, JsonMappingException, IOException {
		HashMap map = (HashMap) new ObjectMapper().readValue(param,
				(TypeReference) new TypeReference<Map<String, Object>>() {
				});
		return this.service.getFacilityPowerUsage(map);
	}

	// 시설별 소비 요금 조회
	@RequestMapping(value = { "/getFacilityPowerCost" }, produces = { "application/json; charset=utf8" })
	@ResponseBody
	public List<HashMap<String, Object>> getFacilityPowerCost(@RequestBody String param)
			throws JsonParseException, JsonMappingException, IOException {
		HashMap map = (HashMap) new ObjectMapper().readValue(param,
				(TypeReference) new TypeReference<Map<String, Object>>() {
				});
		return this.service.getFacilityPowerCost(map);
	}

	// 태양광 태그 현재값 조회 (CO2 저감량, 태양광 금일발전량)
	@RequestMapping(value = { "/getSolarTagValue" }, produces = { "application/json; charset=utf8" })
	@ResponseBody
	public List<HashMap<String, Object>> getSolarTagValue(@RequestBody String param)
			throws JsonParseException, JsonMappingException, IOException {
		HashMap map = (HashMap) new ObjectMapper().readValue(param,
				(TypeReference) new TypeReference<Map<String, Object>>() {
				});
		return this.service.getSolarTagValue(map);
	}

	// 태양광 시간별 데이터 조회 (차트용)
	@RequestMapping(value = { "/getHourlySolarData" }, produces = { "application/json; charset=utf8" })
	@ResponseBody
	public List<HashMap<String, Object>> getHourlySolarData(@RequestBody String param)
			throws JsonParseException, JsonMappingException, IOException {
		HashMap map = (HashMap) new ObjectMapper().readValue(param,
				(TypeReference) new TypeReference<Map<String, Object>>() {
				});
		return this.service.getHourlySolarData(map);
	}

	// 일별 누적 전력량 조회 (최근 30일)
	@RequestMapping(value = { "/getChartDailyPowerUsage" }, produces = { "application/json; charset=utf8" })
	@ResponseBody
	public List<HashMap<String, Object>> getChartDailyPowerUsage(@RequestBody String param)
			throws JsonParseException, JsonMappingException, IOException {
		HashMap map = (HashMap) new ObjectMapper().readValue(param,
				(TypeReference) new TypeReference<Map<String, Object>>() {
				});
		return this.service.getChartDailyPowerUsage(map);
	}

	// 월별 누적 전력량 조회 (최근 12개월)
	@RequestMapping(value = { "/getChartMonthlyPowerUsage" }, produces = { "application/json; charset=utf8" })
	@ResponseBody
	public List<HashMap<String, Object>> getChartMonthlyPowerUsage(@RequestBody String param)
			throws JsonParseException, JsonMappingException, IOException {
		HashMap map = (HashMap) new ObjectMapper().readValue(param,
				(TypeReference) new TypeReference<Map<String, Object>>() {
				});
		return this.service.getChartMonthlyPowerUsage(map);
	}

	// 년도별 누적 전력량 조회 (최근 5년)
	@RequestMapping(value = { "/getChartYearlyPowerUsage" }, produces = { "application/json; charset=utf8" })
	@ResponseBody
	public List<HashMap<String, Object>> getChartYearlyPowerUsage(@RequestBody String param)
			throws JsonParseException, JsonMappingException, IOException {
		HashMap map = (HashMap) new ObjectMapper().readValue(param,
				(TypeReference) new TypeReference<Map<String, Object>>() {
				});
		return this.service.getChartYearlyPowerUsage(map);
	}

	// 일별 소비 요금 조회 (최근 30일)
	@RequestMapping(value = { "/getChartDailyCost" }, produces = { "application/json; charset=utf8" })
	@ResponseBody
	public List<HashMap<String, Object>> getChartDailyCost(@RequestBody String param)
			throws JsonParseException, JsonMappingException, IOException {
		HashMap map = (HashMap) new ObjectMapper().readValue(param,
				(TypeReference) new TypeReference<Map<String, Object>>() {
				});
		return this.service.getChartDailyCost(map);
	}

	// 월별 소비 요금 조회 (최근 12개월)
	@RequestMapping(value = { "/getChartMonthlyCost" }, produces = { "application/json; charset=utf8" })
	@ResponseBody
	public List<HashMap<String, Object>> getChartMonthlyCost(@RequestBody String param)
			throws JsonParseException, JsonMappingException, IOException {
		HashMap map = (HashMap) new ObjectMapper().readValue(param,
				(TypeReference) new TypeReference<Map<String, Object>>() {
				});
		return this.service.getChartMonthlyCost(map);
	}

	// 년도별 소비 요금 조회 (최근 5년)
	@RequestMapping(value = { "/getChartYearlyCost" }, produces = { "application/json; charset=utf8" })
	@ResponseBody
	public List<HashMap<String, Object>> getChartYearlyCost(@RequestBody String param)
			throws JsonParseException, JsonMappingException, IOException {
		HashMap map = (HashMap) new ObjectMapper().readValue(param,
				(TypeReference) new TypeReference<Map<String, Object>>() {
				});
		return this.service.getChartYearlyCost(map);
	}

	// 일별 태양광/CO2 데이터 조회 (최근 30일)
	@RequestMapping(value = { "/getDailySolarData" }, produces = { "application/json; charset=utf8" })
	@ResponseBody
	public List<HashMap<String, Object>> getDailySolarData(@RequestBody String param)
			throws JsonParseException, JsonMappingException, IOException {
		HashMap map = (HashMap) new ObjectMapper().readValue(param,
				(TypeReference) new TypeReference<Map<String, Object>>() {
				});
		return this.service.getDailySolarData(map);
	}

	// 월별 태양광/CO2 데이터 조회 (최근 12개월)
	@RequestMapping(value = { "/getMonthlySolarData" }, produces = { "application/json; charset=utf8" })
	@ResponseBody
	public List<HashMap<String, Object>> getMonthlySolarData(@RequestBody String param)
			throws JsonParseException, JsonMappingException, IOException {
		HashMap map = (HashMap) new ObjectMapper().readValue(param,
				(TypeReference) new TypeReference<Map<String, Object>>() {
				});
		return this.service.getMonthlySolarData(map);
	}

	// 년도별 태양광/CO2 데이터 조회 (최근 5년)
	@RequestMapping(value = { "/getYearlySolarData" }, produces = { "application/json; charset=utf8" })
	@ResponseBody
	public List<HashMap<String, Object>> getYearlySolarData(@RequestBody String param)
			throws JsonParseException, JsonMappingException, IOException {
		HashMap map = (HashMap) new ObjectMapper().readValue(param,
				(TypeReference) new TypeReference<Map<String, Object>>() {
				});
		return this.service.getYearlySolarData(map);
	}

	// 금일 전력량 합계 조회 (DB에서 합산)
	@RequestMapping(value = { "/getTodayPowerUsageTotal" }, produces = { "application/json; charset=utf8" })
	@ResponseBody
	public List<HashMap<String, Object>> getTodayPowerUsageTotal(@RequestBody String param)
			throws JsonParseException, JsonMappingException, IOException {
		HashMap map = (HashMap) new ObjectMapper().readValue(param,
				(TypeReference) new TypeReference<Map<String, Object>>() {
				});
		return this.service.getTodayPowerUsageTotal(map);
	}
}
