package restful.utils;

import jakarta.servlet.http.HttpServletRequest;
import org.jboss.resteasy.plugins.providers.multipart.InputPart;
import org.jboss.resteasy.plugins.providers.multipart.MultipartFormDataInput;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;

import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.MultivaluedMap;
import restful.bean.Result;

import java.io.File;
import java.io.InputStream;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.UUID;


public class UploadFile {
//    @POST
//    @Path("/uploadIcon")
//    @Consumes("multipart/form-data")
//    @Produces("application/json;charset=UTF-8")
//    public Result uploadIcon(MultipartFormDataInput data, @Context HttpServletRequest httpServletRequest) {
//        try {
//            // 获取表单数据
//            Map<String, List<InputPart>> formDataMap = data.getFormDataMap();
//
//            // 获取分类ID
//            String categoryCode = null;
//            if (formDataMap.containsKey("categoryCode")) {
//                List<InputPart> categoryCodeParts = formDataMap.get("categoryCode");
//                if (categoryCodeParts != null && !categoryCodeParts.isEmpty()) {
//                    categoryCode = categoryCodeParts.get(0).getBodyAsString();
//                }
//            }
//
//            if (categoryCode == null || categoryCode.trim().isEmpty()) {
//                return Result.failure("分类编号不能为空");
//            }
//
//            // 获取文件部分
//            List<InputPart> fileParts = formDataMap.get("file");
//            if (fileParts == null || fileParts.isEmpty()) {
//                return Result.failure("请选择要上传的图片");
//            }
//
//            InputPart filePart = fileParts.get(0);
//
//            // 获取文件头信息
//            MultivaluedMap<String, String> headers = filePart.getHeaders();
//            String fileName = getFileName(headers);
//
//            // 验证文件类型
//            if (!isValidImageFile(fileName)) {
//                return Result.failure("只支持图片文件格式（jpg, jpeg, png, gif）");
//            }
//
//            // 生成新的文件名：使用分类编号作为文件名
//            String fileExtension = getFileExtension(fileName);
//            String newFileName = categoryCode + "." + fileExtension;
//
//            // 获取文件输入流
//            InputStream inputStream = filePart.getBody(InputStream.class, null);
//
//            // 获取服务器上的保存路径
//            String uploadPath = httpServletRequest.getServletContext().getRealPath("/images");
//            File uploadDir = new File(uploadPath);
//            if (!uploadDir.exists()) {
//                uploadDir.mkdirs();
//            }
//
//            // 保存文件
//            File targetFile = new File(uploadDir, newFileName);
//            FileUtils.copyInputStreamToFile(inputStream, targetFile);
//
//            // 关闭流
//            inputStream.close();
//
//            // 返回成功结果，包含文件路径信息
//            return Result.success("图标上传成功", newFileName);
//
//        } catch (IOException e) {
//            e.printStackTrace();
//            return Result.failure("文件上传失败：" + e.getMessage());
//        } catch (Exception e) {
//            e.printStackTrace();
//            return Result.failure("系统错误：" + e.getMessage());
//        }
//    }
//
//    // 从headers中提取文件名
//    private String getFileName(MultivaluedMap<String, String> headers) {
//        String[] contentDisposition = headers.getFirst("Content-Disposition").split(";");
//
//        for (String filename : contentDisposition) {
//            if ((filename.trim().startsWith("filename"))) {
//                String[] name = filename.split("=");
//                String finalFileName = name[1].trim().replaceAll("\"", "");
//                return finalFileName;
//            }
//        }
//        return "unknown";
//    }
//
//    // 获取文件扩展名
//    private String getFileExtension(String fileName) {
//        if (fileName.lastIndexOf(".") != -1 && fileName.lastIndexOf(".") != 0) {
//            return fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
//        }
//        return "";
//    }
//
//    // 验证是否为有效的图片文件
//    private boolean isValidImageFile(String fileName) {
//        String extension = getFileExtension(fileName);
//        return extension.equals("jpg") || extension.equals("jpeg") ||
//                extension.equals("png") || extension.equals("gif");
//    }

}
