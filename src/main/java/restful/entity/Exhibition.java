package restful.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "T_Exhibition")
@NamedQueries({
        @NamedQuery(name = "Exhibition.findAll", query = "SELECT e FROM Exhibition e"),
        @NamedQuery(name = "Exhibition.findByExhibitCode", query = "SELECT e FROM Exhibition e WHERE e.exhibitCode = :exhibitCode"),
        @NamedQuery(name = "Exhibition.findByExhibitName", query = "SELECT e FROM Exhibition e WHERE e.exhibitName = :exhibitName"),
        @NamedQuery(name = "Exhibition.findByExhibitNameLike", query = "SELECT e FROM Exhibition e WHERE e.exhibitName LIKE :exhibitName"),
        @NamedQuery(name = "Exhibition.findByCategoryId", query = "SELECT e FROM Exhibition e WHERE e.categoryId = :categoryId"),
        @NamedQuery(name = "Exhibition.deleteByExhibitCode", query = "DELETE FROM Exhibition e WHERE e.exhibitCode = :exhibitCode"),
        @NamedQuery(name = "Exhibition.deleteByCategoryId", query = "DELETE FROM Exhibition e WHERE e.categoryId = :categoryId")
})
@Getter
@Setter
public class Exhibition extends IdEntity {
    @Column(name = "exhibit_code", length = 50, nullable = false)
    private String exhibitCode;

    @Column(name = "exhibit_name", length = 200, nullable = false)
    private String exhibitName;

    @Column(name = "description", columnDefinition = "nvarchar(MAX)")
    private String description;

    @Column(name = "image_path", length = 255)
    private String imagePath;

    @Column(name = "category_id", nullable = false)
    private Long categoryId;

}
