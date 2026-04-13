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


import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.Map;
import java.util.UUID;


@Path("/categories")
public class CategoryAPI {
    @POST
    @Path("/list")
    @Consumes("application/json;charset=UTF-8")
    @Produces("application/json;charset=UTF-8")
    public Result list() {
        List<Category> result = EM.getEntityManager()
                .createNamedQuery("Category.findAll", Category.class)
                .getResultList();
        return new Result(200, "查询成功", result, "");
    }

    @POST
    @Path("/add")
    @Consumes("application/json;charset=UTF-8")
    @Produces("application/json;charset=UTF-8")
    public Result add(Category category) {

        category.setIconPath("category-defualt.png");
        category = EM.getEntityManager().merge(category);
        EM.getEntityManager().persist(category);
        EM.getEntityManager().getTransaction().commit();
        return new Result(200, "添加成功", category, "");
    }

    @POST
    @Path("/update")
    @Consumes("application/json;charset=UTF-8")
    @Produces("application/json;charset=UTF-8")
    public Result update(Category category) {
        category = EM.getEntityManager().merge(category);
        EM.getEntityManager().persist(category);
        EM.getEntityManager().getTransaction().commit();
        return new Result(200, "修改成功", category, "");
    }

    @POST
    @Path("/delete")
    @Consumes("application/json;charset=UTF-8")
    @Produces("application/json;charset=UTF-8")
    public Result delete(Category category) {
        EM.getEntityManager().remove(EM.getEntityManager().merge(category));
        EM.getEntityManager().getTransaction().commit();
        return new Result(200, "成功删除", category, "");
    }

    @POST
    @Path("/info/{id}")
    @Consumes("application/json;charset=UTF-8")
    @Produces("application/json;charset=UTF-8")
    public Result getCategoryInfo(@PathParam("id") Long id) {
        // 根据ID查询分类
        Category category = EM.getEntityManager()
                .createNamedQuery("Category.findById", Category.class)
                .setParameter("id", id)
                .getSingleResult();

        // 直接返回Category对象
        return new Result(200, "查询成功", category, "");

    }

    @POST
    @Path("/uploadIcon")
    @Consumes("multipart/form-data")
    @Produces("application/json;charset=UTF-8")
    public Result uploadIcon(MultipartFormDataInput data, @Context HttpServletRequest httpServletRequest) {
        try {
            // 获取表单数据
            Map<String, List<InputPart>> formDataMap = data.getFormDataMap();

            // 获取分类ID
            String categoryCode = null;
            if (formDataMap.containsKey("categoryCode")) {
                List<InputPart> categoryCodeParts = formDataMap.get("categoryCode");
                if (categoryCodeParts != null && !categoryCodeParts.isEmpty()) {
                    categoryCode = categoryCodeParts.get(0).getBodyAsString();
                }
            }

            if (categoryCode == null || categoryCode.trim().isEmpty()) {
                return Result.failure("分类编号不能为空");
            }

            // 获取文件部分
            List<InputPart> fileParts = formDataMap.get("file");
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
            // E:\大学\大三上\Web与restful\restful\src\main\webapp\images
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // 保存文件
            File targetFile = new File(imagePath);
            FileUtils.copyInputStreamToFile(inputStream, targetFile);

            // 关闭流
            inputStream.close();


            Category category = EM.getEntityManager()
                    .createNamedQuery("Category.findByCategoryCode", Category.class)
                    .setParameter("code", categoryCode)
                    .getResultStream()
                    .findFirst()
                    .orElse(null);

            if (category == null) {
                return new Result(1, "分类不存在", null, "");
            }

            // 更新图标路径
            category.setIconPath(randomFileName);

            // 合并到实体管理器并提交事务
            EM.getEntityManager().merge(category);
            EM.getEntityManager().getTransaction().commit();

            // 返回成功结果，包含文件路径信息
            return Result.success("图标上传成功", randomFileName);

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
