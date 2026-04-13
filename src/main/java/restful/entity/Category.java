package restful.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import jakarta.persistence.Column;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "T_Category") // 表名映射
@NamedQueries({
        @NamedQuery(name = "Category.findAll", query = "SELECT category FROM Category category"),
        @NamedQuery(name = "Category.findByCategoryCode", query = "SELECT category FROM Category category WHERE category.categoryCode = :code"),
        @NamedQuery(name = "Category.findByCategoryName", query = "SELECT category FROM Category category WHERE category.categoryName = :name"),
        @NamedQuery(name = "Category.findById", query = "SELECT category FROM Category category WHERE category.id = :id")
})
@Getter
@Setter
public class Category extends IdEntity {

    @Column(name = "category_code", nullable = false, unique = true) // 对应数据库表中的 `category_code`
    private String categoryCode;

    @Column(name = "category_name", nullable = false) // 对应数据库表中的 `category_name`
    private String categoryName;

    @Column(name = "icon_path") // 对应数据库表中的 `icon_path`
    private String iconPath;
}
