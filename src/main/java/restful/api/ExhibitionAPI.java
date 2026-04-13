package restful.api;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.MultivaluedMap;
import org.apache.commons.io.FileUtils;
import org.jboss.resteasy.plugins.providers.multipart.InputPart;
import org.jboss.resteasy.plugins.providers.multipart.MultipartFormDataInput;
import restful.bean.Result;
import restful.database.EM;
import restful.entity.Category;
import restful.entity.Exhibition;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Path("/exhibits")
public class ExhibitionAPI {
    @POST
    @Path("/list")
    @Consumes("application/json;charset=UTF-8")
    @Produces("application/json;charset=UTF-8")
    public Result list() {
        List<Exhibition> result = EM.getEntityManager()
                .createNamedQuery("Exhibition.findAll", Exhibition.class)
                .getResultList();
        return new Result(200, "查询成功", result, "");
    }

    @POST
    @Path("/add")
    @Consumes("application/json;charset=UTF-8")
    @Produces("application/json;charset=UTF-8")
    public Result add(Exhibition exhibition) {

        exhibition.setImagePath("default-exhibit.jpg");
        exhibition = EM.getEntityManager().merge(exhibition);
        EM.getEntityManager().persist(exhibition);
        EM.getEntityManager().getTransaction().commit();
        return new Result(200, "添加成功", exhibition, "");
    }

    @POST
    @Path("/update")
    @Consumes("application/json;charset=UTF-8")
    @Produces("application/json;charset=UTF-8")
    public Result update(Exhibition exhibition) {
        exhibition = EM.getEntityManager().merge(exhibition);
        EM.getEntityManager().persist(exhibition);
        EM.getEntityManager().getTransaction().commit();
        return new Result(200, "修改成功", exhibition, "");
    }

    @POST
    @Path("/delete")
    @Consumes("application/json;charset=UTF-8")
    @Produces("application/json;charset=UTF-8")
    public Result delete(Exhibition exhibition) {
        EM.getEntityManager().remove(EM.getEntityManager().merge(exhibition));
        EM.getEntityManager().getTransaction().commit();
        return new Result(200, "成功删除", exhibition, "");
    }

    // category/
    @POST
    @Path("/category/{id}")
    @Consumes("application/json;charset=UTF-8")
    @Produces("application/json;charset=UTF-8")
    public Result getByCategoryId(@PathParam("id") Long id) {

        // 根据ID查询分类
        List<Exhibition> exhibition = EM.getEntityManager()
                .createNamedQuery("Exhibition.findByCategoryId", Exhibition.class)
                .setParameter("categoryId", id)
                .getResultList();

        // 直接返回Category对象
        return new Result(200, "查询成功", exhibition, "");

    }
    // uploadImage

    @POST
    @Path("/uploadExhibitImage")
    @Consumes("multipart/form-data")
    @Produces("application/json;charset=UTF-8")
    public Result uploadExhibitImage(MultipartFormDataInput data, @Context HttpServletRequest httpServletRequest) {
        try {
            // 获取表单数据
            Map<String, List<InputPart>> formDataMap = data.getFormDataMap();

            // 获取展品编号
            String exhibitCode = null;
            if (formDataMap.containsKey("exhibitCode")) {
                List<InputPart> exhibitCodeParts = formDataMap.get("exhibitCode");
                if (exhibitCodeParts != null && !exhibitCodeParts.isEmpty()) {
                    exhibitCode = exhibitCodeParts.get(0).getBodyAsString();
                }
            }

            if (exhibitCode == null || exhibitCode.trim().isEmpty()) {
                return Result.failure("展品编号不能为空");
            }

            // 获取文件部分
            List<InputPart> fileParts = formDataMap.get("image");
            if (fileParts == null || fileParts.isEmpty()) {
                return Result.failure("请选择要上传的图片");
            }

            InputPart filePart = fileParts.get(0);

            // 获取文件头信息
            MultivaluedMap<String, String> headers = filePart.getHeaders();
            String fileName = getFileName(headers);
            String extension = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
            System.out.println(extension);

            // 获取文件输入流
            InputStream inputStream = filePart.getBody(InputStream.class, null);

            // 使用相对路径保存到 src/main/webapp/images
            String uploadPath = httpServletRequest.getServletContext().getRealPath("/");
            String randomFileName = UUID.randomUUID().toString() + extension;
            String imagePath = uploadPath + "images\\" + randomFileName;

            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // 保存文件
            File targetFile = new File(imagePath);
            FileUtils.copyInputStreamToFile(inputStream, targetFile);

            // 关闭流
            inputStream.close();

            // 查找展品
            Exhibition exhibition = EM.getEntityManager()
                    .createNamedQuery("Exhibition.findByExhibitCode", Exhibition.class)
                    .setParameter("exhibitCode", exhibitCode)
                    .getResultStream()
                    .findFirst()
                    .orElse(null);

            if (exhibition == null) {
                return new Result(1, "展品不存在", null, "");
            }

            // 更新图片路径
            exhibition.setImagePath(randomFileName);

            // 合并到实体管理器并提交事务
            EM.getEntityManager().merge(exhibition);
            EM.getEntityManager().getTransaction().commit();

            // 返回成功结果，包含文件路径信息
            return Result.success("展品图片上传成功", randomFileName);

        } catch (IOException e) {
            e.printStackTrace();
            return Result.failure("文件上传失败：" + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            return Result.failure("系统错误：" + e.getMessage());
        }
    }
    // 从headers中提取文件名
    private String getFileName(MultivaluedMap<String, String> headers) {
        String[] contentDisposition = headers.getFirst("Content-Disposition").split(";");

        for (String filename : contentDisposition) {
            if ((filename.trim().startsWith("filename"))) {
                String[] name = filename.split("=");
                String finalFileName = name[1].trim().replaceAll("\"", "");
                return finalFileName;
            }
        }
        return "unknown";
    }
}
