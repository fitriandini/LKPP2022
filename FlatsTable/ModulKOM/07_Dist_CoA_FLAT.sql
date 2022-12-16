DROP MATERIALIZED VIEW SAKTIKSL.MV_KOM_DIST_COA_220930_221023;
CREATE MATERIALIZED VIEW SAKTIKSL.MV_KOM_DIST_COA_220930_221023
AS
SELECT	AA.ID_DIST_COA,
		AA.DELETED,
		CASE	WHEN AA.DELETED = '0' THEN 'aktif'
				WHEN AA.DELETED = '1' THEN 'deleted'
			END AS UR_DELETED,
		AA.KODE_GLP_T_COA,
		substr(aa.KODE_GLP_T_COA,12,6)	kode_akun,
		ff.DESKRIPSI					NAMA_AKUN,
		AA.KODE_KPPN,
		TRIM(EE.NMKPPN)					NAMA_KPPN,
		substr(bb.kode_unit,1,3)		kode_ba_satker,
		trim(cc.deskripsi)				nama_ba_satker,
		substr(bb.kode_unit,-2)			kode_eselon1_satker,
		trim(dd.deskripsi)				nama_eselon1_satker,
		AA.KODE_SATKER,
		trim(bb.deskripsi)				nama_satker,
		AA.NILAI,
		AA.SEQ_DIST_COA,
		AA.USED,
		CASE	WHEN AA.USED = '0' THEN 'Used'
				WHEN AA.USED = '1' THEN 'Unused'
			END AS UR_USED,
		AA.JADWAL_PEMBAYARAN_ID
FROM	SAKTIKSL.BPK_KOM_DIST_COA_220930_221023	AA
left join	SAKTIKSL.BPK_ADM_R_SATKER_220731 bb
	ON	aa.KODE_SATKER = bb.KODE
left join
	(	SELECT	DISTINCT *
		FROM	saktiksl.BPK_ADM_R_KEMENTERIAN_220731
		WHERE	LEVEL_ = '1'
	) cc
	ON	substr(bb.kode_unit,1,3) = cc.KODE
LEFT JOIN
	(	SELECT	DISTINCT *
		FROM	saktiksl.BPK_ADM_R_KEMENTERIAN_220731
		WHERE	LEVEL_ = '2'
	) dd
	ON	bb.kode_unit = dd.KODE
LEFT JOIN	EREKON.T_KPPN_220525	EE
	ON	AA.KODE_KPPN = EE.KDKPPN
left join	SAKTIKSL.BPK_ADM_R_AKUN_220731	ff
	ON	substr(aa.KODE_GLP_T_COA,12,6) = ff.KODE;
CREATE INDEX SAKTIKSL.IDX_MV_KDCOA_221023_BA ON SAKTIKSL.MV_KOM_DIST_COA_220930_221023 (kode_ba_satker);
CREATE INDEX SAKTIKSL.IDX_MV_KDCOA_221023_BAES1 ON SAKTIKSL.MV_KOM_DIST_COA_220930_221023 (kode_ba_satker||kode_eselon1_satker);