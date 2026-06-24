package com.dsan.web.ai.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.dsan.web.ai.vo.EvntVO;
import com.dsan.web.ai.vo.ImgFileVO;

@Mapper
public interface Ai0101Mapper {
	public List<EvntVO> getEvntList(EvntVO vo);

	public List<ImgFileVO> getAtchFileList(ImgFileVO vo);

	public int getNextEvntId();

	public int onSaveEvntInfo(EvntVO vo);

	public int onSaveEvntAtchFile(ImgFileVO vo);

	public int onDeleteEvntInfo(EvntVO vo);

	public int onDeleteEvntAtchFile(EvntVO vo);

	public List<EvntVO> getReport(EvntVO vo);
}