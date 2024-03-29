DROP MATERIALIZED VIEW SAKTIKSL.MV_BEN_UPLOAD_DATA_PEN_220930_221023;
CREATE MATERIALIZED VIEW SAKTIKSL.MV_BEN_UPLOAD_DATA_PEN_220930_221023
AS
--Tabel mencatat upload data penerimaan
SELECT	AA.JUMLAH,
		AA.DELETED,
		CASE	WHEN AA.DELETED = '0' THEN 'data aktif'
				WHEN AA.DELETED = '1' THEN 'data dihapus'
			END AS UR_DELETED,
		AA.KODE_AKUN,
		trim(bb.DESKRIPSI)					NAMA_AKUN,
		AA.KODE_DEPT,
		TRIM(CC.DESKRIPSI)					NAMA_DEPT,
		AA.KODE_UNIT,
		TRIM(DD.DESKRIPSI)					NAMA_UNIT,
		AA.KODE_SATKER,		
		TRIM(EE.DESKRIPSI)					NAMA_satker,
		AA.KODE_KEWENANGAN,
		AA.KODE_PROGRAM,
		AA.KODE_OUTPUT,
		AA.KODE_MATA_UANG,
		AA.KODE_KPPN,
		TRIM(JJ.NMKPPN)						NAMA_KPPN,
		AA.NO_PENAGIHAN,
		AA.NO_REF_GL,
		AA.NTB,
		AA.NTPN,
		AA.BUDGET_TYPE,
		AA.TGL_BUKU,
		AA.KODE_LOKASI,
		TRIM(KK.DESKRIPSI)					NAMA_LOKASI,
		AA.KODE_KAB_KOTA,
		AA.KETERANGAN,
		AA.NO_UPLOAD,
		AA.MATCHING_PIUTANG,
		AA.SALDO_PIUTANG
FROM	saktiksl.BPK_BEN_UPLOAD_DATA_PEN_220930_221023	AA
LEFT JOIN	SAKTIKSL.BPK_ADM_R_AKUN_220731	BB
	ON	AA.KODE_AKUN = BB.KODE
left join
	(	SELECT	DISTINCT *
		FROM	saktiksl.BPK_ADM_R_KEMENTERIAN_220731
		WHERE	LEVEL_ = '1'
	) CC
	ON	AA.KODE_DEPT = CC.KODE
LEFT JOIN
	(	SELECT	DISTINCT *
		FROM	saktiksl.BPK_ADM_R_KEMENTERIAN_220731
		WHERE	LEVEL_ = '2'
	) DD
	ON	KODE_DEPT||'.'||KODE_UNIT = DD.KODE
left join	SAKTIKSL.BPK_ADM_R_SATKER_220731 EE
	ON	aa.KODE_SATKER = EE.KODE
LEFT JOIN	EREKON.T_KPPN_220525	JJ
	ON	AA.KODE_KPPN = JJ.KDKPPN
LEFT JOIN
	(	SELECT	*
		FROM	SAKTIKSL.BPK_ADM_R_LOKASI_220731
		WHERE	LEVEL_ = '3'
	) KK
	ON	SUBSTR(AA.KODE_LOKASI,1,2)||'.'||SUBSTR(AA.KODE_LOKASI,-2) = KK.KODE;
CREATE INDEX SAKTIKSL.IDX_MV_BUDP_221023_BA ON SAKTIKSL.BPK_BEN_UPLOAD_DATA_PEN_220930_221023(KODE_DEPT);
CREATE INDEX SAKTIKSL.IDX_MV_BUDP_221023_BAES1 ON SAKTIKSL.BPK_BEN_UPLOAD_DATA_PEN_220930_221023(KODE_DEPT||KODE_UNIT);
CREATE INDEX SAKTIKSL.IDX_MV_BUDP_221023_REFGL ON SAKTIKSL.BPK_BEN_UPLOAD_DATA_PEN_220930_221023(NO_REF_GL);
CREATE INDEX SAKTIKSL.IDX_MV_BUDP_221023_NTPN ON SAKTIKSL.BPK_BEN_UPLOAD_DATA_PEN_220930_221023(NTPN);