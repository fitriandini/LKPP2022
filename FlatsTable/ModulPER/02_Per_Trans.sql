drop materialized view saktiksl.MV_PER_T_TRANS_220930_221023;
create materialized view saktiksl.MV_PER_T_TRANS_220930_221023
as
WITH
PER_TRANS_ALL AS
(	SELECT	*
	FROM	SAKTIKSL.BPK_PER_T_TRANS_2021_221023
	UNION ALL
	SELECT	*
	FROM	SAKTIKSL.BPK_PER_T_TRANS_220930_221023
)
SELECT	AA.ID,
		AA.ASAL_BARANG,
		CASE	WHEN substr(ASAL_BARANG,1,3) = 'LK_' then substr(ASAL_BARANG,1,8)
				WHEN substr(ASAL_BARANG,1,4) = 'BAST' THEN
					CASE	WHEN substr(ASAL_BARANG,1,5) = 'BAST-' THEN substr(ASAL_BARANG,1,4)
							WHEN substr(ASAL_BARANG,1,9) = 'BAST_NONK' THEN substr(ASAL_BARANG,1,9)
							WHEN substr(ASAL_BARANG,1,10) = 'BAST_HIBAH' THEN substr(ASAL_BARANG,1,10)
						END
			END AS DOK_ASAL,
		CASE	WHEN substr(ASAL_BARANG,1,3) = 'LK_' then substr(ASAL_BARANG,10,LENGTH(ASAL_BARANG))
				WHEN substr(ASAL_BARANG,1,4) = 'BAST' THEN
					CASE	WHEN substr(ASAL_BARANG,1,5) = 'BAST-' THEN SUBSTR(ASAL_BARANG,6,LENGTH(ASAL_BARANG))
							WHEN substr(ASAL_BARANG,1,9) = 'BAST_NONK' THEN SUBSTR(ASAL_BARANG,11,LENGTH(ASAL_BARANG))
							WHEN substr(ASAL_BARANG,1,10) = 'BAST_HIBAH' THEN SUBSTR(ASAL_BARANG,12,LENGTH(ASAL_BARANG))
						END
				ELSE ASAL_BARANG
			END AS ID_DOK_ASAL,
		AA.HARGA_TOTAL,
		AA.JENIS_TRANSAKSI,
		TRIM(BB.DESKRIPSI)					NAMA_TRANSAKSI,
		AA.MTD_PNCTTN,
		AA.NO_BUKTI,
		AA.NO_DOKUMEN,
		AA.ORGANISASI,
		AA.PERIODE_TUTUP_BUKU,
		AA.PREV_ADK_ID,
		AA.PREV_TRANS_ID,
		AA.SATKER,
		AA.STATUS,
		CASE	WHEN AA.STATUS = 'PA' THEN 'Belum disetujui'
				WHEN AA.STATUS = 'SA' THEN 'Sudah disetujui (Pembantu Satker)'
				WHEN AA.STATUS = 'A' THEN 'Sudah disetujui (Satker Induk)'
				WHEN AA.STATUS = 'NA' THEN 'Perlu Persetujuan Ulang'
				WHEN AA.STATUS = 'AV' THEN 'Perlu Aktivasi'
				WHEN AA.STATUS = 'AC' THEN 'Perlu Koreksi'
			END AS UR_STATUS,
 		AA.TAHUN_ANGGARAN,
		AA.TGL_DISETUJUI,
		AA.TGL_DOKUMEN,
		AA.TGL_PEMBUKUAN,
		AA.UAKPB,
		SUBSTR(AA.UAKPB,1,3)				KODE_BA_SATKER,
		trim(DD.deskripsi)					nama_ba_satker,
		SUBSTR(AA.UAKPB,4,2)				KODE_ESELON1_SATKER,
		trim(EE.deskripsi)					nama_eselon1_satker,
		SUBSTR(AA.UAKPB,10,6)				KODE_SATKER,
		trim(CC.deskripsi)					nama_satker,
		SUBSTR(AA.UAKPB,16,3)				KODE_SUBSATKER,
		SUBSTR(AA.UAKPB,1,5)||'.'||SUBSTR(AA.UAKPB,10,6)||'.'||SUBSTR(AA.UAKPB,16,3)
			||'.'||SUBSTR(AA.UAKPB,-2)		KODE_NUP, 
		AA.UAKPB_LAINNYA,
		SUBSTR(AA.UAKPB_LAINNYA,10,6)		KODE_BA_SATKER_LAINNYA,
		trim(GG.deskripsi)					nama_ba_satker_LAINNYA,
		SUBSTR(AA.UAKPB_LAINNYA,10,6)		KODE_ESELON1_SATKER_LAINNYA,
		trim(HH.deskripsi)					nama_eselon1_satker_LAINNYA,
		SUBSTR(AA.UAKPB_LAINNYA,10,6)		KODE_SATKER_LAINNYA,
		trim(FF.deskripsi)					nama_satker_LAINNYA,
		SUBSTR(AA.UAKPB_LAINNYA,16,3)		KODE_SUBSATKER_LAINNYA,
		CASE	WHEN AA.UAKPB_LAINNYA IS NOT NULL THEN 
					SUBSTR(AA.UAKPB_LAINNYA,1,5)||'.'||SUBSTR(AA.UAKPB_LAINNYA,10,6)||'.'||SUBSTR(AA.UAKPB_LAINNYA,16,3)
						||'.'||SUBSTR(AA.UAKPB_LAINNYA,-2)	
			END AS KODE_NUP_LAINNYA, 
		AA.PER_T_ADK,
		AA.UAKPB_INDUK
FROM	PER_TRANS_ALL	AA
LEFT JOIN	SAKTIKSL.BPK_ADM_R_JENIS_TRANSAKSI_220731	BB
	ON	AA.JENIS_TRANSAKSI = BB.KODE
left join	SAKTIKSL.BPK_ADM_R_SATKER_220731 CC
	ON	SUBSTR(AA.UAKPB,10,6) = CC.KODE
left join
	(	SELECT	DISTINCT *
		FROM	saktiksl.BPK_ADM_R_KEMENTERIAN_220731
		WHERE	LEVEL_ = '1'
	) DD
	ON	SUBSTR(AA.UAKPB,1,3) = DD.KODE
LEFT JOIN
	(	SELECT	DISTINCT *
		FROM	saktiksl.BPK_ADM_R_KEMENTERIAN_220731
		WHERE	LEVEL_ = '2'
	) EE
	ON	SUBSTR(AA.UAKPB,1,3)||'.'||SUBSTR(AA.UAKPB,4,2) = EE.KODE
left join	SAKTIKSL.BPK_ADM_R_SATKER_220731 FF
	ON	SUBSTR(AA.UAKPB_LAINNYA,10,6) = FF.KODE
left join
	(	SELECT	DISTINCT *
		FROM	saktiksl.BPK_ADM_R_KEMENTERIAN_220731
		WHERE	LEVEL_ = '1'
	) GG
	ON	SUBSTR(AA.UAKPB_LAINNYA,1,3) = GG.KODE
LEFT JOIN
	(	SELECT	DISTINCT *
		FROM	saktiksl.BPK_ADM_R_KEMENTERIAN_220731
		WHERE	LEVEL_ = '2'
	) HH
	ON	SUBSTR(AA.UAKPB_LAINNYA,1,3)||'.'||SUBSTR(AA.UAKPB_LAINNYA,4,2) = HH.KODE;
create index saktiksl.MV_PTTRN_221023_BA on saktiksl.MV_PER_T_TRANS_220930_221023 (kode_ba_satker);
create index saktiksl.MV_PTTRN_221023_BAES1 on saktiksl.MV_PER_T_TRANS_220930_221023 (kode_ba_satker||kode_eselon1_satker);
create index saktiksl.MV_PTTRN_221023_ID on saktiksl.MV_PER_T_TRANS_220930_221023 (ID);