DROP MATERIALIZED VIEW SAKTIKSL.MV_BEN_SETORAN_PJK_BEN_PEN_220930_221023;
CREATE MATERIALIZED VIEW SAKTIKSL.MV_BEN_SETORAN_PJK_BEN_PEN_220930_221023
--Tabel mencatat setoran pajak
AS
SELECT	AA.KODE_AKUN,
		TRIM(BB.DESKRIPSI)					NAMA_AKUN,
		AA.DELETED,
		CASE	when AA.DELETED = '0' then 'data aktif'
				when AA.DELETED = '1' then 'data dihapus'
			end as ur_DELETED,
		AA.CARA_SETOR,
		CASE	when AA.CARA_SETOR = '0' then 'Tunai'
				when AA.CARA_SETOR = '1' then 'Non Tunai'
			end as ur_CARA_SETOR,
		AA.JENIS_SETORAN,
		CC.URAIAN							NAMA_JNS_SETOR,
		CC.SEKTOR							SEKTOR_JNS_SETOR,
		AA.JUMLAH_SETOR_PAJAK,
		AA.KETERANGAN,
		AA.MASA_PAJAK,
		AA.NO_REF_GL,
		AA.NO_SSP,
		AA.NTPN,
		substr(DD.kode_unit,1,3)			kode_ba_satker,
		trim(EE.deskripsi)					nama_ba_satker,
		substr(DD.kode_unit,-2)				kode_eselon1_satker,
		trim(FF.deskripsi)					nama_eselon1_satker,
		AA.KODE_SATKER,
		trim(DD.deskripsi)					nama_satker,
		AA.KODE_TAHUN_ANGGARAN,
		AA.TGL_TERIMA_BANK,
		AA.TIPE_SETORAN,
		AA.KODE_UNIT_TEKNIS,
		AA.NTB
FROM	SAKTIKSL.BPK_BEN_SETORAN_PJK_BEN_PEN_220930_221023	AA
LEFT JOIN	SAKTIKSL.BPK_ADM_R_AKUN_220731	BB
	ON	AA.KODE_AKUN = BB.KODE
LEFT JOIN	SAKTIKSL.REF_JENIS_SETORAN_PAJAK_2022	CC
	ON	AA.KODE_AKUN = CC.KD_MAP
		AND AA.JENIS_SETORAN = CC.KD_BAYAR
left join	SAKTIKSL.BPK_ADM_R_SATKER_220731 DD
	ON	aa.KODE_SATKER = DD.KODE
left join
	(	SELECT	DISTINCT *
		FROM	saktiksl.BPK_ADM_R_KEMENTERIAN_220731
		WHERE	LEVEL_ = '1'
	) EE
	ON	substr(DD.kode_unit,1,3) = EE.KODE
LEFT JOIN
	(	SELECT	DISTINCT *
		FROM	saktiksl.BPK_ADM_R_KEMENTERIAN_220731
		WHERE	LEVEL_ = '2'
	) FF
	ON	DD.kode_unit = FF.KODE;
CREATE INDEX SAKTIKSL.IDX_MV_BSPJKBP_221023_ba ON SAKTIKSL.MV_BEN_SETORAN_PJK_BEN_PEN_220930_221023(kode_ba_satker);
CREATE INDEX SAKTIKSL.IDX_MV_BSPJKBP_221023_baES1 ON SAKTIKSL.MV_BEN_SETORAN_PJK_BEN_PEN_220930_221023(kode_ba_satker||kode_eselon1_satker);