package com.dsan.web.ai.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dsan.web.ai.mapper.Ai0101Mapper;
import com.dsan.web.ai.vo.EvntVO;
import com.dsan.web.ai.vo.ImgFileVO;

@Service
public class Ai0101Service {
	@Autowired
	private Ai0101Mapper mapper;

	public List<EvntVO> getEvntList(EvntVO vo) {
		return mapper.getEvntList(vo);
	}

	public List<ImgFileVO> getAtchFileList(ImgFileVO vo) {
		return mapper.getAtchFileList(vo);
	}

	public int getNextEvntId() {
		return mapper.getNextEvntId();
	}

	public int onSaveEvntInfo(EvntVO vo) {
		return mapper.onSaveEvntInfo(vo);
	}

	public int onSaveEvntAtchFile(ImgFileVO vo) {
		return mapper.onSaveEvntAtchFile(vo);
	}

	// 이벤트 삭제
	public int onDeleteEvntInfo(EvntVO vo) {
		return mapper.onDeleteEvntInfo(vo);
	}

	public int onDeleteEvntAtchFile(EvntVO vo) {
		return mapper.onDeleteEvntAtchFile(vo);
	}

	public List<EvntVO> getReport(EvntVO vo) {
		return mapper.getReport(vo);
	}
}