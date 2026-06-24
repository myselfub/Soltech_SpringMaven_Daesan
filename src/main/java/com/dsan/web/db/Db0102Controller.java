package com.dsan.web.db;

import com.dsan.web.db.service.Db0102Service;
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
public class Db0102Controller {
    private static final Logger LOGGER = LoggerFactory.getLogger(Db0102Controller.class);

    @Autowired
    private Db0102Service service;

    // 금일 최근 알람 4건
    @RequestMapping(value={"/getAlarmRecent"}, produces={"application/json; charset=utf8"})
    @ResponseBody
    public List<HashMap<String, Object>> getAlarmRecent(@RequestBody String param) throws JsonParseException, JsonMappingException, IOException {
        HashMap map = (HashMap)new ObjectMapper().readValue(param, (TypeReference)new TypeReference<Map<String, Object>>(){});
        return this.service.getAlarmRecent(map);
    }

    // 금일 태그별 알람 건수 TOP 20
    @RequestMapping(value={"/getAlarmTop20"}, produces={"application/json; charset=utf8"})
    @ResponseBody
    public List<HashMap<String, Object>> getAlarmTop20(@RequestBody String param) throws JsonParseException, JsonMappingException, IOException {
        HashMap map = (HashMap)new ObjectMapper().readValue(param, (TypeReference)new TypeReference<Map<String, Object>>(){});
        return this.service.getAlarmTop20(map);
    }

    // 약품 사용현황
    @RequestMapping(value={"/getChemicalUsage"}, produces={"application/json; charset=utf8"})
    @ResponseBody
    public List<HashMap<String, Object>> getChemicalUsage(@RequestBody String param) throws JsonParseException, JsonMappingException, IOException {
        HashMap map = (HashMap)new ObjectMapper().readValue(param, (TypeReference)new TypeReference<Map<String, Object>>(){});
        return this.service.getChemicalUsage(map);
    }

    // 시간별 물생산량
    @RequestMapping(value={"/getHourlyWaterProduction"}, produces={"application/json; charset=utf8"})
    @ResponseBody
    public List<HashMap<String, Object>> getHourlyWaterProduction(@RequestBody String param) throws JsonParseException, JsonMappingException, IOException {
        HashMap map = (HashMap)new ObjectMapper().readValue(param, (TypeReference)new TypeReference<Map<String, Object>>(){});
        return this.service.getHourlyWaterProduction(map);
    }

    // 일별 물생산량
    @RequestMapping(value={"/getDailyWaterProduction"}, produces={"application/json; charset=utf8"})
    @ResponseBody
    public List<HashMap<String, Object>> getDailyWaterProduction(@RequestBody String param) throws JsonParseException, JsonMappingException, IOException {
        HashMap map = (HashMap)new ObjectMapper().readValue(param, (TypeReference)new TypeReference<Map<String, Object>>(){});
        return this.service.getDailyWaterProduction(map);
    }

    // 월별 물생산량
    @RequestMapping(value={"/getMonthlyWaterProduction"}, produces={"application/json; charset=utf8"})
    @ResponseBody
    public List<HashMap<String, Object>> getMonthlyWaterProduction(@RequestBody String param) throws JsonParseException, JsonMappingException, IOException {
        HashMap map = (HashMap)new ObjectMapper().readValue(param, (TypeReference)new TypeReference<Map<String, Object>>(){});
        return this.service.getMonthlyWaterProduction(map);
    }

    // 년도별 물생산량
    @RequestMapping(value={"/getYearlyWaterProduction"}, produces={"application/json; charset=utf8"})
    @ResponseBody
    public List<HashMap<String, Object>> getYearlyWaterProduction(@RequestBody String param) throws JsonParseException, JsonMappingException, IOException {
        HashMap map = (HashMap)new ObjectMapper().readValue(param, (TypeReference)new TypeReference<Map<String, Object>>(){});
        return this.service.getYearlyWaterProduction(map);
    }

    // 시간별 전력원단위
    @RequestMapping(value={"/getHourlyPowerIntensity"}, produces={"application/json; charset=utf8"})
    @ResponseBody
    public List<HashMap<String, Object>> getHourlyPowerIntensity(@RequestBody String param) throws JsonParseException, JsonMappingException, IOException {
        HashMap map = (HashMap)new ObjectMapper().readValue(param, (TypeReference)new TypeReference<Map<String, Object>>(){});
        return this.service.getHourlyPowerIntensity(map);
    }

    // 일별 전력원단위
    @RequestMapping(value={"/getDailyPowerIntensity"}, produces={"application/json; charset=utf8"})
    @ResponseBody
    public List<HashMap<String, Object>> getDailyPowerIntensity(@RequestBody String param) throws JsonParseException, JsonMappingException, IOException {
        HashMap map = (HashMap)new ObjectMapper().readValue(param, (TypeReference)new TypeReference<Map<String, Object>>(){});
        return this.service.getDailyPowerIntensity(map);
    }

    // 월별 전력원단위
    @RequestMapping(value={"/getMonthlyPowerIntensity"}, produces={"application/json; charset=utf8"})
    @ResponseBody
    public List<HashMap<String, Object>> getMonthlyPowerIntensity(@RequestBody String param) throws JsonParseException, JsonMappingException, IOException {
        HashMap map = (HashMap)new ObjectMapper().readValue(param, (TypeReference)new TypeReference<Map<String, Object>>(){});
        return this.service.getMonthlyPowerIntensity(map);
    }

    // 년도별 전력원단위
    @RequestMapping(value={"/getYearlyPowerIntensity"}, produces={"application/json; charset=utf8"})
    @ResponseBody
    public List<HashMap<String, Object>> getYearlyPowerIntensity(@RequestBody String param) throws JsonParseException, JsonMappingException, IOException {
        HashMap map = (HashMap)new ObjectMapper().readValue(param, (TypeReference)new TypeReference<Map<String, Object>>(){});
        return this.service.getYearlyPowerIntensity(map);
    }

    // 일별 약품사용량
    @RequestMapping(value={"/getDailyChemicalUsage"}, produces={"application/json; charset=utf8"})
    @ResponseBody
    public List<HashMap<String, Object>> getDailyChemicalUsage(@RequestBody String param) throws JsonParseException, JsonMappingException, IOException {
        HashMap map = (HashMap)new ObjectMapper().readValue(param, (TypeReference)new TypeReference<Map<String, Object>>(){});
        return this.service.getDailyChemicalUsage(map);
    }

    // 월별 약품사용량
    @RequestMapping(value={"/getMonthlyChemicalUsage"}, produces={"application/json; charset=utf8"})
    @ResponseBody
    public List<HashMap<String, Object>> getMonthlyChemicalUsage(@RequestBody String param) throws JsonParseException, JsonMappingException, IOException {
        HashMap map = (HashMap)new ObjectMapper().readValue(param, (TypeReference)new TypeReference<Map<String, Object>>(){});
        return this.service.getMonthlyChemicalUsage(map);
    }

    // 년도별 약품사용량
    @RequestMapping(value={"/getYearlyChemicalUsage"}, produces={"application/json; charset=utf8"})
    @ResponseBody
    public List<HashMap<String, Object>> getYearlyChemicalUsage(@RequestBody String param) throws JsonParseException, JsonMappingException, IOException {
        HashMap map = (HashMap)new ObjectMapper().readValue(param, (TypeReference)new TypeReference<Map<String, Object>>(){});
        return this.service.getYearlyChemicalUsage(map);
    }

    // 생산수 수질 (최신 1분 데이터)
    @RequestMapping(value={"/getWaterQualityLatest"}, produces={"application/json; charset=utf8"})
    @ResponseBody
    public List<HashMap<String, Object>> getWaterQualityLatest(@RequestBody String param) throws JsonParseException, JsonMappingException, IOException {
        HashMap map = (HashMap)new ObjectMapper().readValue(param, (TypeReference)new TypeReference<Map<String, Object>>(){});
        return this.service.getWaterQualityLatest(map);
    }
}
