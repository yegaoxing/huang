package jp.co.ginga.infra.repository.facility;
//5566
import static org.hamcrest.CoreMatchers.*;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.junit.Assert.fail;
import static org.junit.jupiter.api.Assertions.assertEquals;
//7788
import java.sql.Timestamp;
import java.util.List;

import org.dbunit.operation.DatabaseOperation;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import jp.co.ginga.infra.repository.facilityType.FacilityTypeEntity;
import jp.co.ginga.infra.repository.user.UserEntity;
import jp.co.ginga.infra.util.PostgreDataManager;

@ExtendWith(SpringExtension.class)
@SpringBootTest
@TestPropertySource(locations = "classpath:application-test.properties")
public class FacilityRepositoryTest {

	@Autowired
	FacilityRepository facilityRepository;

	/**
	 * 施設情報 リポジトリ 全件検索処理 データ全件の場合
	 */

	@Test
	public void findAllMultipleData() {

		try {
			PostgreDataManager.dataSet("./data/infra/repository/Facility/setup_dataset_facility.xml",
					DatabaseOperation.CLEAN_INSERT);
			// CLEAN_INSERTでpgadminに登録しているデータを削除して再セットする

		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("データセット失敗");
			fail();
		}

		List<FacilityEntity> list = facilityRepository.findAll();
		assertEquals(list.size(), 2);

		for (int i = 0; i < list.size(); i++) {
			assertEquals(6 + (i), list.get(i).getFacilityId());
			assertEquals("会議室" + (i + 1), list.get(i).getName());
			assertEquals(10 + (i), list.get(i).getCapacity());
			assertEquals(1 + (i), list.get(i).getFacilityTypeEntity().getFacilityTypeId());
			//			assertEquals("会議室", list.get(i).getFacilityTypeEntity().getName());

		}

	}

	/**
	 * 施設情報 リポジトリ 全件検索処理 データが1件の場合
	 */

	@Test
	public void findAllSingleData() {

		try {
			PostgreDataManager.dataSet("./data/infra/repository/Facility/setup_single_dataset_facility.xml",
					DatabaseOperation.CLEAN_INSERT);

		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("データセット失敗");
			fail();
		}

		List<FacilityEntity> list = facilityRepository.findAll();

		assertEquals(list.size(), 1);
		assertEquals(10, list.get(0).getFacilityId());
		assertEquals("会議室1", list.get(0).getName());
		assertEquals(10, list.get(0).getCapacity());
		assertEquals(1, list.get(0).getFacilityTypeEntity().getFacilityTypeId());

	}

	/**
	 * 施設情報 リポジトリ 全件検索処理 データが0件の場合
	 */
	@Test
	public void findAllNoData() {

		try {
			PostgreDataManager.dataSet("./data/infra/repository/Facility/setup_nodata_dataset_facility.xml",
					DatabaseOperation.CLEAN_INSERT);

		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("データセット失敗");
			fail();
			// fail()：強制的に失敗になる
		}

		List<FacilityEntity> list = facilityRepository.findAll();

		assertEquals(list.size(), 0 );

	}
	/**
	 * 施設情報 リポジトリ findByFacilityTypeId  データが複数件場合
	 */
	public void findByFacilityTypeIdMultipleData() {
		try {
			PostgreDataManager.dataSet("./data/infra/repository/Facility/setup_dataset_facility.xml",
					DatabaseOperation.CLEAN_INSERT);
			// CLEAN_INSERTでpgadminに登録しているデータを削除して再セットする

		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("データセット失敗");
			fail();
		}

		List<FacilityEntity> list = facilityRepository.findByFacilityTypeId(1);
		for (int i = 0; i < list.size(); i++) {
		assertEquals(list.size(), 2);
		assertEquals("会議室"+ (i + 1), list.get(0).getName());
		assertEquals(10 + i, list.get(0).getCapacity());
		assertEquals(1 + i, list.get(0).getFacilityTypeEntity().getFacilityTypeId());
	}
	}
	
	
	/**
	 * 施設情報 リポジトリ findByFacilityTypeId  データが1件場合
	 */
	public void findByFacilityTypeIdSingleData() {
		try {
			PostgreDataManager.dataSet("./data/infra/repository/Facility/setup_dataset_facility.xml",
					DatabaseOperation.CLEAN_INSERT);
			// CLEAN_INSERTでpgadminに登録しているデータを削除して再セットする

		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("データセット失敗");
			fail();
		}

		List<FacilityEntity> list = facilityRepository.findByFacilityTypeId(1);
		assertEquals(list.size(), 1);
		assertEquals("会議室1", list.get(0).getName());
		assertEquals(10, list.get(0).getCapacity());
		assertEquals(1, list.get(0).getFacilityTypeEntity().getFacilityTypeId());
	}
	
	/**
	 * 施設情報 リポジトリ findByFacilityTypeId  データがない場合
	 */
	public void findByFacilityTypeIdNoData() {
		try {
			PostgreDataManager.dataSet("./data/infra/repository/Facility/setup_dataset_facility.xml",
					DatabaseOperation.CLEAN_INSERT);
			// CLEAN_INSERTでpgadminに登録しているデータを削除して再セットする

		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("データセット失敗");
			fail();
		}

		List<FacilityEntity> list = facilityRepository.findByFacilityTypeId(1);
		assertEquals(0, list.size());
	}

	/**
	 * ユーザー情報 リポジトリ 登録処理 重複なし
	 */
	//	@Test
	//	public void findByNameData() {
	//		try {
	//			PostgreDataManager.dataSet("./data/infra/repository/Facility/setup_dataset_facility.xml",
	//					DatabaseOperation.CLEAN_INSERT);
	//
	//		} catch (Exception e) {
	//			e.printStackTrace();
	//			System.out.println("データセット失敗");
	//			fail();
	//			// fail()：強制的に失敗になる
	//		}
	//
	//		List<FacilityEntity> list = facilityRepository.findByName("会議室1");
	//
	//		assertEquals(list.size(), 1);
	//
	//		assertEquals("会議室1", list.get(0).getName());
	//
	//	}
	/**
	 * 施設情報 リポジトリ 登録処理 重複なし
	 */
	@Test
	public void insertOk() {
		try {
			PostgreDataManager.dataSet("./data/infra/repository/Facility/setup_dataset_facility.xml",
					DatabaseOperation.CLEAN_INSERT);

		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("データセット失敗");
			fail();
		}
		// テストデータ
		FacilityTypeEntity facilityTypeEntity = new FacilityTypeEntity();
		UserEntity updateUserEntity = new UserEntity();
		String datetime = "2019-05-01 01:02:03";
		String name = "会議室1";
		int capacity = 10;
		facilityTypeEntity.setFacilityTypeId(1);
		Timestamp insertDate = Timestamp.valueOf(datetime);
		updateUserEntity.setUserId("2");

		FacilityEntity facilityEntity = new FacilityEntity();
		facilityEntity.setName(name);
		facilityEntity.setCapacity(capacity);
		facilityEntity.setFacilityTypeEntity(facilityTypeEntity);
		facilityEntity.setInsertDate(insertDate);
		facilityEntity.setUpdateUserEntity(updateUserEntity);
		// テスト実施メソッド
		int result = facilityRepository.insert(facilityEntity);
		// 検証処理
		assertEquals(1, result);

		List<FacilityEntity> result1 = facilityRepository.findByName("会議室1");
		//		List<FacilityEntity> result1 = facilityRepository.findByFacilityId(6);

		// String(参照型)		
		assertEquals(true, facilityEntity.getName().equals(result1.get(0).getName()));
		//		// int(基本データ型)
		//		assertEquals(facilityEntity.getCapacity(), result1.get(0).getCapacity());
		//		assertEquals(facilityEntity.getFacilityTypeEntity(), result1.get(0).getFacilityTypeEntity());
		//		assertEquals(facilityEntity.getUpdateUserEntity(), result1.get(0).getUpdateUserEntity());
		//		// Timestamp
		//		assertEquals(true, facilityEntity.getInsertDate().equals(result1.get(0).getInsertDate()));
	}

	/**
	 * 施設情報 リポジトリ 登録処理 重複あり
	 */
	@Test
	public void insertNo() {

		try {
			PostgreDataManager.dataSet("./data/infra/repository/Facility/setup_dataset_facility.xml",
					DatabaseOperation.CLEAN_INSERT);

		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("データセット失敗");
			fail();
		}

		// テストデータ
		FacilityTypeEntity facilityTypeEntity = new FacilityTypeEntity();
		UserEntity updateUserEntity = new UserEntity();
		String datetime = "2019-05-01 01:02:03";
		String name = "会議室111111111111111111111111111111111111111111";
		int capacity = 10;
		facilityTypeEntity.setFacilityTypeId(1);
		Timestamp insertDate = Timestamp.valueOf(datetime);
		updateUserEntity.setUserId("2");

		FacilityEntity facilityEntity = new FacilityEntity();
		facilityEntity.setName(name);
		//		facilityEntity.setCapacity(capacity);
		//		facilityEntity.setFacilityTypeEntity(facilityTypeEntity);
		//		facilityEntity.setInsertDate(insertDate);
		//		facilityEntity.setUpdateUserEntity(updateUserEntity);

		try {
			// テスト実施メソッド
			facilityRepository.insert(facilityEntity);
			fail("例外発生なし");
		} catch (Exception e) {
			// スキーマ違反例外を期待
			assertThat(e, is(instanceOf(DataIntegrityViolationException.class)));
		}

	}

	/**
	 * 施設情報 リポジトリ 登録処理 境界値 ユーザ名 異常系 文字数 21
	 */
	@Test
	public void insertNg() {

		try {
			PostgreDataManager.dataSet("./data/infra/repository/Facility/setup_dataset_facility.xml",
					DatabaseOperation.CLEAN_INSERT);

		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("データセット失敗");
			fail();
		}
		// テストデータ
		FacilityTypeEntity facilityTypeEntity = new FacilityTypeEntity();
		UserEntity updateUserEntity = new UserEntity();
		String datetime = "2019-05-01 01:02:03";
		String name = "会議室1111111111111111111111111111111111111111111";
		int capacity = 10;
		facilityTypeEntity.setFacilityTypeId(1);
		Timestamp insertDate = Timestamp.valueOf(datetime);
		updateUserEntity.setUserId("2");

		FacilityEntity facilityEntity = new FacilityEntity();
		facilityEntity.setName(name);
		//		facilityEntity.setCapacity(capacity);
		//		facilityEntity.setFacilityTypeEntity(facilityTypeEntity);
		//		facilityEntity.setInsertDate(insertDate);
		//		facilityEntity.setUpdateUserEntity(updateUserEntity);
		try {
			// テスト実施メソッド
			facilityRepository.insert(facilityEntity);
			fail("例外発生なし");
		} catch (Exception e) {
			// スキーマ違反例外を期待
			assertThat(e, is(instanceOf(DataIntegrityViolationException.class)));
		}

	}

	/**
	 * 施設情報 リポジトリ 更新処理 全データ更新処理
	 */

	@Test
	public void updateOk() {
		try {
			PostgreDataManager.dataSet("./data/infra/repository/Facility/setup_dataset_facility.xml",
					DatabaseOperation.CLEAN_INSERT);

		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("データセット失敗");
			fail();
		}
		// テストデータ
		FacilityTypeEntity facilityTypeEntity = new FacilityTypeEntity();
		UserEntity updateUserEntity = new UserEntity();
		String datetime = "2019-05-01 01:02:03";
		String name = "会議室2";
		int capacity = 10;
		int facilityId = 6;
		facilityTypeEntity.setFacilityTypeId(1);
		Timestamp updateDate = Timestamp.valueOf(datetime);
		updateUserEntity.setUserId("2");

		FacilityEntity facilityEntity = new FacilityEntity();
		facilityEntity.setName(name);
		facilityEntity.setFacilityId(facilityId);
		facilityEntity.setCapacity(capacity);
		facilityEntity.setFacilityTypeEntity(facilityTypeEntity);
		facilityEntity.setInsertDate(updateDate);
		facilityEntity.setUpdateUserEntity(updateUserEntity);
		// テスト実施メソッド
		int result = facilityRepository.update(facilityEntity);
		// 検証処理
		assertEquals(1, result);
	}

	/**
	 * 施設情報 リポジトリ 更新処理 境界値 ユーザ名 異常系 文字数 21
	 */

	@Test
	public void updateNg() {
		try {
			PostgreDataManager.dataSet("./data/infra/repository/Facility/setup_dataset_facility.xml",
					DatabaseOperation.CLEAN_INSERT);

		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("データセット失敗");
			fail();
		}
		// テストデータ
		FacilityTypeEntity facilityTypeEntity = new FacilityTypeEntity();
		UserEntity updateUserEntity = new UserEntity();
		String datetime = "2019-05-01 01:02:03";
		String name = "会議室2222222222222222222222222222222222222222";
		int capacity = 10;
		int facilityId = 6;
		facilityTypeEntity.setFacilityTypeId(1);
		Timestamp updateDate = Timestamp.valueOf(datetime);
		updateUserEntity.setUserId("2");

		FacilityEntity facilityEntity = new FacilityEntity();
		facilityEntity.setName(name);
		facilityEntity.setFacilityId(facilityId);
		facilityEntity.setCapacity(capacity);
		facilityEntity.setFacilityTypeEntity(facilityTypeEntity);
		facilityEntity.setInsertDate(updateDate);
		facilityEntity.setUpdateUserEntity(updateUserEntity);
		// テスト実施メソッド
		try {
			// テスト実施メソッド
			facilityRepository.update(facilityEntity);
			fail("例外発生なし");
		} catch (Exception e) {
			// スキーマ違反例外を期待
			assertThat(e, is(instanceOf(DataIntegrityViolationException.class)));
		}
	}

	/**
	 * 施設情報 リポジトリ 削除処理
	 */

	@Test
	public void deleteOk() {
		try {
			PostgreDataManager.dataSet("./data/infra/repository/Facility/setup_dataset_facility.xml",
					DatabaseOperation.CLEAN_INSERT);

		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("データセット失敗");
			fail();
		}

		int result = facilityRepository.delete(6);

		assertEquals(1, result);
	}

	/**
	 * 施設情報 リポジトリ 削除処理 データなし
	 */

	@Test
	public void deleteNg() {
		try {
			PostgreDataManager.dataSet("./data/infra/repository/util/setup_nodata.xml",
					DatabaseOperation.CLEAN_INSERT);

		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("データセット失敗");
			fail();
		}
		int result = facilityRepository.delete(6);

		assertEquals(0, result);
	}

	// 
}
